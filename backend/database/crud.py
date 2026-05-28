"""
CRUD helpers.

Keeping DB writes here (not inside route handlers) means:
- Route handlers stay thin and testable.
- DB logic is reusable across routes.
- Switching persistence layers later only requires editing this file.
"""
from __future__ import annotations

import logging
import uuid
from typing import Optional

from sqlalchemy import select
from sqlalchemy.exc import IntegrityError
from sqlalchemy.ext.asyncio import AsyncSession

from database.models import Report, ReportType, User

logger = logging.getLogger(__name__)


# ===========================================================================
# User CRUD
# ===========================================================================

async def create_user(
    db: AsyncSession,
    email: str,
    hashed_password: Optional[str] = None,
    full_name: Optional[str] = None,
    firebase_uid: Optional[str] = None,
    is_verified: bool = False,
) -> User:
    """
    Insert a new user row and return it.

    Raises:
        ValueError: if the email is already registered.
    """
    user = User(
        email=email,
        hashed_password=hashed_password,
        full_name=full_name,
        firebase_uid=firebase_uid,
        is_verified=is_verified,
    )
    db.add(user)
    try:
        await db.flush()
    except IntegrityError:
        await db.rollback()
        raise ValueError(f"Email '{email}' is already registered.")
    logger.info("Created user id=%s email=%s", user.id, user.email)
    return user


async def get_user_by_email(db: AsyncSession, email: str) -> Optional[User]:
    """Return the User with the given email, or None."""
    result = await db.execute(select(User).where(User.email == email))
    return result.scalar_one_or_none()


async def get_user_by_id(db: AsyncSession, user_id: uuid.UUID) -> Optional[User]:
    """Return the User with the given UUID, or None."""
    result = await db.execute(select(User).where(User.id == user_id))
    return result.scalar_one_or_none()


async def get_user_by_firebase_uid(
    db: AsyncSession,
    firebase_uid: str,
) -> Optional[User]:
    """Return the User linked to a Firebase UID, or None."""
    result = await db.execute(
        select(User).where(User.firebase_uid == firebase_uid)
    )
    return result.scalar_one_or_none()


async def get_or_create_firebase_user(
    db: AsyncSession,
    *,
    firebase_uid: str,
    email: str,
    full_name: Optional[str] = None,
    is_verified: bool = False,
) -> User:
    """
    Find or create an app user for a Firebase-authenticated identity.

    Links existing email accounts to the Firebase UID when possible.
    Updates profile fields on every successful login/sync.
    """
    user = await get_user_by_firebase_uid(db, firebase_uid)
    if user is not None:
        user.is_verified = is_verified or user.is_verified
        if full_name:
            user.full_name = full_name
        return user

    existing = await get_user_by_email(db, email)
    if existing is not None:
        existing.firebase_uid = firebase_uid
        existing.is_verified = is_verified or existing.is_verified
        if full_name:
            existing.full_name = full_name
        return existing

    try:
        return await create_user(
            db=db,
            email=email,
            firebase_uid=firebase_uid,
            full_name=full_name,
            is_verified=is_verified,
        )
    except ValueError:
        # Race: another request created the same email — link and return.
        existing = await get_user_by_email(db, email)
        if existing is None:
            raise
        existing.firebase_uid = firebase_uid
        existing.is_verified = is_verified or existing.is_verified
        if full_name:
            existing.full_name = full_name
        return existing


# ===========================================================================
# Report CRUD
# ===========================================================================

async def save_report(
    db: AsyncSession,
    report_type: ReportType,
    ai_provider: str,
    input_data: dict,
    output_data: dict,
    raw_output: Optional[str] = None,
    user_id: Optional[uuid.UUID] = None,
) -> Report:
    """
    Persist a single AI-generated report and return the saved instance.

    The caller is responsible for committing the session (get_db does this
    automatically at the end of the request).
    """
    report = Report(
        report_type=report_type,
        ai_provider=ai_provider,
        input_data=input_data,
        output_data=output_data,
        raw_output=raw_output,
        user_id=user_id,
    )
    db.add(report)
    await db.flush()
    logger.info("Saved %s report id=%s provider=%s", report_type.value, report.id, ai_provider)
    return report


async def get_report(db: AsyncSession, report_id: uuid.UUID) -> Optional[Report]:
    """Fetch a single report by its UUID."""
    result = await db.execute(select(Report).where(Report.id == report_id))
    return result.scalar_one_or_none()


async def list_reports(
    db: AsyncSession,
    user_id: Optional[uuid.UUID] = None,
    report_type: Optional[ReportType] = None,
    limit: int = 20,
    offset: int = 0,
) -> list[Report]:
    """
    Return a paginated list of reports, newest first.
    Filters by user_id and/or report_type when provided.
    """
    query = (
        select(Report)
        .order_by(Report.created_at.desc())
        .limit(limit)
        .offset(offset)
    )
    if user_id is not None:
        query = query.where(Report.user_id == user_id)
    if report_type is not None:
        query = query.where(Report.report_type == report_type)
    result = await db.execute(query)
    return list(result.scalars().all())
