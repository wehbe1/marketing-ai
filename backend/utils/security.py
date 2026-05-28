"""
Cryptographic utilities — password hashing and JWT tokens.

This module has ZERO FastAPI imports. It is pure Python so it can be
tested in isolation and reused by any layer of the application.
"""
from __future__ import annotations

from datetime import datetime, timedelta, timezone
from typing import Any

import bcrypt
from jose import JWTError, jwt

from config import settings

# ---------------------------------------------------------------------------
# Constants
# ---------------------------------------------------------------------------

ALGORITHM = "HS256"

# ---------------------------------------------------------------------------
# Password hashing  (bcrypt directly — avoids passlib/bcrypt 4.x compat issues)
# ---------------------------------------------------------------------------

def hash_password(plain: str) -> str:
    """Return the bcrypt hash of a plain-text password."""
    return bcrypt.hashpw(plain.encode("utf-8"), bcrypt.gensalt()).decode("utf-8")


def verify_password(plain: str, hashed: str) -> bool:
    """Return True if *plain* matches the stored bcrypt *hashed* value."""
    return bcrypt.checkpw(plain.encode("utf-8"), hashed.encode("utf-8"))


# ---------------------------------------------------------------------------
# JWT tokens
# ---------------------------------------------------------------------------

def create_access_token(
    subject: str | Any,
    expires_delta: timedelta | None = None,
) -> str:
    """
    Encode a signed JWT access token.

    Args:
        subject:       The value stored in the ``sub`` claim — use the user's UUID string.
        expires_delta: Custom lifetime. Defaults to ACCESS_TOKEN_EXPIRE_MINUTES from .env.

    Returns:
        A signed JWT string.
    """
    delta = expires_delta or timedelta(minutes=settings.access_token_expire_minutes)
    expire = datetime.now(timezone.utc) + delta
    payload: dict = {
        "sub": str(subject),
        "exp": expire,
        "type": "access",
    }
    return jwt.encode(payload, settings.secret_key, algorithm=ALGORITHM)


def decode_access_token(token: str) -> dict:
    """
    Decode and verify a JWT access token.

    Returns:
        The decoded payload dict.

    Raises:
        jose.JWTError: If the token is invalid, expired, or tampered with.
    """
    payload = jwt.decode(token, settings.secret_key, algorithms=[ALGORITHM])
    if payload.get("type") != "access":
        raise JWTError("Invalid token type.")
    return payload
