"""
FastAPI dependency functions for authentication.

Two dependencies are provided:

get_current_user    — REQUIRED auth. Returns the User or raises HTTP 401.
                      Use on endpoints that MUST be authenticated.

get_optional_user   — OPTIONAL auth. Returns the User when a valid token is
                      present, or None for anonymous requests.
                      Use on AI-generation endpoints so they work both
                      anonymously and for logged-in users (who get their
                      reports linked automatically).
"""
from __future__ import annotations

import uuid
from typing import Optional

from fastapi import Depends, HTTPException, Request, status
from fastapi.security import OAuth2PasswordBearer
from jose import JWTError
from sqlalchemy.ext.asyncio import AsyncSession

from database.crud import get_user_by_id
from database.db import get_db
from database.models import User
from utils.security import decode_access_token

# tokenUrl is used by Swagger UI's "Authorize" button only.
# Our /auth/login endpoint accepts JSON (Flutter-friendly), not form data.
_oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/auth/login", auto_error=False)


# ---------------------------------------------------------------------------
# Required auth — raises 401 if no valid token
# ---------------------------------------------------------------------------

async def get_current_user(
    token: Optional[str] = Depends(_oauth2_scheme),
    db: Optional[AsyncSession] = Depends(get_db),
) -> User:
    """
    Require a valid JWT Bearer token.
    Raises HTTP 401 if token is missing, invalid, or expired.
    Raises HTTP 503 if the database is not configured.
    """
    _require_db(db)

    if not token:
        raise _credentials_error()

    user = await _resolve_token(token, db)  # type: ignore[arg-type]
    if user is None or not user.is_active:
        raise _credentials_error()
    return user


# ---------------------------------------------------------------------------
# Optional auth — returns None for anonymous requests
# ---------------------------------------------------------------------------

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

    return await _resolve_token(token, db)


# ---------------------------------------------------------------------------
# Internal helpers
# ---------------------------------------------------------------------------

async def _resolve_token(token: str, db: AsyncSession) -> Optional[User]:
    """Decode the JWT and load the user from the DB. Returns None on any error."""
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
