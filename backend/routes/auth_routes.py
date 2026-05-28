"""
Authentication endpoints.

POST /auth/register  — create a new account (legacy JWT)
POST /auth/login     — verify credentials (legacy JWT)
POST /auth/sync      — create or update user from Firebase ID token
GET  /auth/me        — return current user profile (Firebase or JWT)
"""
from __future__ import annotations

import logging
from datetime import timedelta

from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy.ext.asyncio import AsyncSession

from config import settings
from database.crud import create_user, get_or_create_firebase_user, get_user_by_email
from database.db import get_db
from database.models import User
from dependencies import get_current_user
from models.auth_models import (
    AuthResponse,
    LoginRequest,
    RegisterRequest,
    SyncRequest,
    SyncResponse,
    UserResponse,
)
from utils.firebase_auth import (
    extract_firebase_identity,
    is_firebase_configured,
    verify_firebase_token,
)
from utils.security import create_access_token, hash_password, verify_password

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/auth", tags=["auth"])
_bearer_scheme = HTTPBearer(auto_error=False)


def _build_auth_response(user: User) -> AuthResponse:
    """Build the standard login/register response payload."""
    expires_seconds = settings.access_token_expire_minutes * 60
    token = create_access_token(
        subject=str(user.id),
        expires_delta=timedelta(minutes=settings.access_token_expire_minutes),
    )
    return AuthResponse(
        access_token=token,
        expires_in=expires_seconds,
        user=UserResponse.model_validate(user),
    )


def _require_db(db):
    if db is None:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Database is not configured. Add DATABASE_URL to .env.",
        )


def _require_firebase_admin() -> None:
    if not is_firebase_configured():
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail=(
                "Firebase Admin is not configured on the server. "
                "Set FIREBASE_CREDENTIALS_JSON in the environment."
            ),
        )


def _decode_firebase_bearer_token(
    credentials: HTTPAuthorizationCredentials | None,
) -> dict:
    _require_firebase_admin()

    if credentials is None or not credentials.credentials:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Missing Firebase ID token.",
            headers={"WWW-Authenticate": "Bearer"},
        )

    decoded = verify_firebase_token(credentials.credentials)
    if decoded is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or expired Firebase token.",
            headers={"WWW-Authenticate": "Bearer"},
        )

    identity = extract_firebase_identity(decoded)
    if identity is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Firebase token is missing required claims (uid/email).",
            headers={"WWW-Authenticate": "Bearer"},
        )

    return identity


@router.post(
    "/register",
    response_model=AuthResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Create a new account (legacy JWT)",
)
async def register(
    body: RegisterRequest,
    db: AsyncSession | None = Depends(get_db),
):
    """Register a new user with email and password."""
    _require_db(db)

    existing = await get_user_by_email(db, body.email)  # type: ignore[arg-type]
    if existing:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="An account with this email already exists.",
        )

    try:
        user = await create_user(
            db=db,  # type: ignore[arg-type]
            email=body.email,
            hashed_password=hash_password(body.password),
            full_name=body.full_name,
        )
    except ValueError as exc:
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail=str(exc))

    return _build_auth_response(user)


@router.post(
    "/login",
    response_model=AuthResponse,
    summary="Sign in and receive an access token (legacy JWT)",
)
async def login(
    body: LoginRequest,
    db: AsyncSession | None = Depends(get_db),
):
    """Authenticate with email and password; returns a JWT access token."""
    _require_db(db)

    user = await get_user_by_email(db, body.email)  # type: ignore[arg-type]

    invalid_credentials = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Invalid email or password.",
        headers={"WWW-Authenticate": "Bearer"},
    )

    if user is None:
        raise invalid_credentials

    if not user.hashed_password or not verify_password(body.password, user.hashed_password):
        raise invalid_credentials

    if not user.is_active:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="This account has been deactivated.",
        )

    return _build_auth_response(user)


@router.post(
    "/sync",
    response_model=SyncResponse,
    summary="Sync Firebase identity to app user record",
)
async def sync_user(
    body: SyncRequest,
    credentials: HTTPAuthorizationCredentials | None = Depends(_bearer_scheme),
    db: AsyncSession | None = Depends(get_db),
):
    """
    Upsert the local user profile after Firebase sign-in.

    Requires ``Authorization: Bearer <Firebase ID token>``.
    """
    _require_db(db)

    identity = _decode_firebase_bearer_token(credentials)
    full_name = body.full_name or identity.get("full_name")

    try:
        user = await get_or_create_firebase_user(
            db,  # type: ignore[arg-type]
            firebase_uid=identity["firebase_uid"],
            email=identity["email"],
            full_name=full_name,
            is_verified=identity["is_verified"],
        )
    except SQLAlchemyError as exc:
        logger.exception("Failed to sync Firebase user to database.")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to sync user profile.",
        ) from exc

    return SyncResponse(user=UserResponse.model_validate(user))


@router.get(
    "/me",
    response_model=UserResponse,
    summary="Get current user profile",
)
async def get_me(current_user: User = Depends(get_current_user)):
    """
    Return the profile of the currently authenticated user.
    Accepts Firebase ID tokens or legacy JWT Bearer tokens.
    """
    return UserResponse.model_validate(current_user)
