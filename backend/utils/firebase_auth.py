"""
Firebase Admin SDK — ID token verification.

Configure one of:
  FIREBASE_CREDENTIALS_JSON  — full service-account JSON as a string (Render-friendly)
  FIREBASE_CREDENTIALS_PATH  — path to service-account JSON file (local dev)
  GOOGLE_APPLICATION_CREDENTIALS — standard GCP env var pointing to a JSON file
"""
from __future__ import annotations

import json
import logging
import os
from typing import Any, Optional

import firebase_admin
from firebase_admin import auth as firebase_auth
from firebase_admin import credentials

from config import settings

logger = logging.getLogger(__name__)

_app: Optional[firebase_admin.App] = None


def is_firebase_configured() -> bool:
    """True when service-account credentials are available for token verification."""
    if settings.firebase_credentials_json.strip():
        return True
    if settings.firebase_credentials_path.strip():
        return True
    gac = os.environ.get("GOOGLE_APPLICATION_CREDENTIALS", "").strip()
    return bool(gac and os.path.isfile(gac))


def _load_credentials() -> Optional[credentials.Certificate]:
    if settings.firebase_credentials_json.strip():
        return credentials.Certificate(json.loads(settings.firebase_credentials_json))

    if settings.firebase_credentials_path.strip():
        return credentials.Certificate(settings.firebase_credentials_path)

    gac = os.environ.get("GOOGLE_APPLICATION_CREDENTIALS", "").strip()
    if gac and os.path.isfile(gac):
        return credentials.Certificate(gac)

    return None


def _init_firebase() -> None:
    global _app
    if _app is not None:
        return

    cred = _load_credentials()
    if cred is not None:
        _app = firebase_admin.initialize_app(cred)
        return

    logger.error(
        "Firebase Admin is not configured. Set FIREBASE_CREDENTIALS_JSON "
        "or FIREBASE_CREDENTIALS_PATH on the server."
    )


def verify_firebase_token(token: str) -> Optional[dict[str, Any]]:
    """
    Verify a Firebase ID token and return decoded claims, or None on failure.
    """
    if not is_firebase_configured():
        logger.error("Cannot verify Firebase token — Admin credentials missing.")
        return None

    try:
        _init_firebase()
        if _app is None:
            return None
        return firebase_auth.verify_id_token(token, check_revoked=True)
    except firebase_auth.RevokedIdTokenError:
        logger.info("Firebase token was revoked.")
        return None
    except firebase_auth.ExpiredIdTokenError:
        logger.info("Firebase token expired.")
        return None
    except Exception as exc:
        logger.warning("Firebase token verification failed: %s", exc)
        return None


def extract_firebase_identity(decoded: dict[str, Any]) -> Optional[dict[str, Any]]:
    """Normalize uid/email/name claims from a verified Firebase token."""
    firebase_uid = decoded.get("uid") or decoded.get("sub") or decoded.get("user_id")
    email = decoded.get("email")
    if not firebase_uid or not email:
        return None

    return {
        "firebase_uid": str(firebase_uid),
        "email": str(email),
        "full_name": decoded.get("name"),
        "is_verified": bool(decoded.get("email_verified", False)),
    }
