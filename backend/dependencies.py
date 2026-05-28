"""
FastAPI dependency functions for authentication.

Supports both Firebase ID tokens (primary) and legacy JWT Bearer tokens.
"""
from __future__ import annotations

import logging
import uuid
from typing import Optional

from fastapi import Depends, HTTPException, Request, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from jose import JWTError
from sqlalchemy.ext.asyncio import AsyncSession

from database.crud import get_or_create_firebase_user, get_user_by_id
from database.db import get_db
from database.models import User
from utils.firebase_auth import (
    extract_firebase_identity,
    is_firebase_configured,
    verify_firebase_token,
)
from utils.security import decode_access_token

logger = logging.getLogger(__name__)

_bearer_scheme = HTTPBearer(auto_error=False)


async def get_current_user(
    credentials: Optional[HTTPAuthorizationCredentials] = Depends(_bearer_scheme),
    db: Optional[AsyncSession] = Depends(get_db),
) -> User:
    """
    Require a valid Bearer token (Firebase ID token or legacy JWT).
    Raises HTTP 401 if token is missing, invalid, expired, or revoked.
    Raises HTTP 503 if the database is not configured.
    """
    _require_db(db)

    if credentials is None or not credentials.credentials:
        raise _credentials_error()

    user = await _resolve_bearer_token(credentials.credentials, db)  # type: ignore[arg-type]
    if user is None or not user.is_active:
        raise _credentials_error()
    return user


async def get_optional_user(
    request: Request,
    db: Optional[AsyncSession] = Depends(get_db),
) -> Optional[User]:
    """
    Soft auth dependency — does NOT raise 401.

    Returns the authenticated User when a valid Bearer token is present,
    or None for anonymous requests. Silently ignores invalid/expired tokens.
    """
    if db is None:
        return None

    auth_header = request.headers.get("Authorization", "")
    if not auth_header.startswith("Bearer "):
        return None

    token = auth_header.split(" ", 1)[1].strip()
    if not token:
        return None

    return await _resolve_bearer_token(token, db)


async def _resolve_bearer_token(token: str, db: AsyncSession) -> Optional[User]:
    """Resolve a Bearer token to a User via Firebase or legacy JWT."""
    if is_firebase_configured():
        decoded = verify_firebase_token(token)
        if decoded is not None:
            identity = extract_firebase_identity(decoded)
            if identity is not None:
                try:
                    return await get_or_create_firebase_user(
                        db,
                        firebase_uid=identity["firebase_uid"],
                        email=identity["email"],
                        full_name=identity.get("full_name"),
                        is_verified=identity["is_verified"],
                    )
                except Exception:
                    logger.exception("Failed to resolve Firebase user from token.")
                    return None

    try:
        payload = decode_access_token(token)
        user_id = uuid.UUID(payload["sub"])
    except (JWTError, KeyError, ValueError):
        return None

    return await get_user_by_id(db, user_id)


def _credentials_error() -> HTTPException:
    return HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials.",
        headers={"WWW-Authenticate": "Bearer"},
    )


def _require_db(db: Optional[AsyncSession]) -> None:
    if db is None:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Database is not configured. Add DATABASE_URL to .env.",
        )
