"""
Authentication endpoints.

POST /auth/register  — create a new account, returns token + user profile
POST /auth/login     — verify credentials, returns token + user profile
GET  /auth/me        — return current user profile (requires valid token)
"""
from __future__ import annotations

from datetime import timedelta

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession

from database.crud import create_user, get_user_by_email
from database.db import get_db
from database.models import User
from dependencies import get_current_user
from models.auth_models import AuthResponse, LoginRequest, RegisterRequest, UserResponse
from utils.security import (
    create_access_token,
    hash_password,
    verify_password,
)
from config import settings

router = APIRouter(prefix="/auth", tags=["auth"])


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

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


# ---------------------------------------------------------------------------
# Endpoints
# ---------------------------------------------------------------------------

@router.post(
    "/register",
    response_model=AuthResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Create a new account",
)
async def register(
    body: RegisterRequest,
    db: AsyncSession | None = Depends(get_db),
):
    """
    Register a new user.

    - Email must be unique.
    - Password is hashed with bcrypt before storage.
    - Returns an access token and the user profile on success.
    """
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
    summary="Sign in and receive an access token",
)
async def login(
    body: LoginRequest,
    db: AsyncSession | None = Depends(get_db),
):
    """
    Authenticate with email and password.

    Returns an access token (JWT) and the user profile.
    Pass the token as ``Authorization: Bearer <token>`` on subsequent requests.
    """
    _require_db(db)

    user = await get_user_by_email(db, body.email)  # type: ignore[arg-type]

    # Use the same error message for both "user not found" and "wrong password"
    # to prevent email enumeration attacks.
    invalid_credentials = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Invalid email or password.",
        headers={"WWW-Authenticate": "Bearer"},
    )

    if user is None:
        raise invalid_credentials

    if not verify_password(body.password, user.hashed_password):
        raise invalid_credentials

    if not user.is_active:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="This account has been deactivated.",
        )

    return _build_auth_response(user)


@router.get(
    "/me",
    response_model=UserResponse,
    summary="Get current user profile",
)
async def get_me(current_user: User = Depends(get_current_user)):
    """
    Return the profile of the currently authenticated user.
    Requires a valid ``Authorization: Bearer <token>`` header.
    """
    return UserResponse.model_validate(current_user)
