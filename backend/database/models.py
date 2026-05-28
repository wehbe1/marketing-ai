"""
SQLAlchemy ORM models.

All models inherit from Base (defined in database/db.py) and use
SQLAlchemy 2.0 Mapped / mapped_column type-annotated style.

Tables
------
users   – application accounts (used by the auth system in Phase 3)
reports – every AI-generated marketing plan or social post
"""
from __future__ import annotations

import enum
import uuid
from datetime import datetime, timezone

from sqlalchemy import (
    Boolean,
    DateTime,
    ForeignKey,
    JSON,
    String,
    Text,
    UniqueConstraint,
)
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from database.db import Base


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def _now() -> datetime:
    return datetime.now(timezone.utc)


# ---------------------------------------------------------------------------
# Enums
# ---------------------------------------------------------------------------

class UserRole(str, enum.Enum):
    USER = "user"
    ADMIN = "admin"


class ReportType(str, enum.Enum):
    MARKETING = "marketing"
    POST = "post"


# ---------------------------------------------------------------------------
# User
# ---------------------------------------------------------------------------

class User(Base):
    """
    Application user account.

    Passwords are stored as bcrypt hashes (never plain-text).
    Authentication (JWT) will be wired in Phase 3.
    """
    __tablename__ = "users"
    __table_args__ = (
        UniqueConstraint("email", name="uq_users_email"),
        UniqueConstraint("firebase_uid", name="uq_users_firebase_uid"),
    )

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        primary_key=True,
        default=uuid.uuid4,
    )
    email: Mapped[str] = mapped_column(
        String(255),
        nullable=False,
        index=True,
    )
    firebase_uid: Mapped[str | None] = mapped_column(
        String(128),
        nullable=True,
        index=True,
    )
    hashed_password: Mapped[str | None] = mapped_column(
        String(255),
        nullable=True,
    )
    full_name: Mapped[str | None] = mapped_column(
        String(255),
        nullable=True,
    )
    role: Mapped[str] = mapped_column(
        String(50),
        default=UserRole.USER.value,
        nullable=False,
        server_default=UserRole.USER.value,
    )
    is_active: Mapped[bool] = mapped_column(
        Boolean,
        default=True,
        nullable=False,
        server_default="true",
    )
    is_verified: Mapped[bool] = mapped_column(
        Boolean,
        default=False,
        nullable=False,
        server_default="false",
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        default=_now,
        nullable=False,
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        default=_now,
        onupdate=_now,
        nullable=False,
    )

    # One user → many reports
    reports: Mapped[list[Report]] = relationship(
        "Report",
        back_populates="user",
        cascade="all, delete-orphan",
        lazy="select",
    )

    def __repr__(self) -> str:
        return f"<User id={self.id} email={self.email!r}>"


# ---------------------------------------------------------------------------
# Report
# ---------------------------------------------------------------------------

class Report(Base):
    """
    Persisted AI-generated output.

    Stores both the raw input payload and the structured AI response as JSONB
    so we can replay, audit, or re-display any past report without calling
    the AI again.

    user_id is nullable so anonymous (pre-auth) usage can still be recorded.
    It will be filled in once the auth system is live.
    """
    __tablename__ = "reports"

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        primary_key=True,
        default=uuid.uuid4,
    )
    user_id: Mapped[uuid.UUID | None] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("users.id", ondelete="SET NULL"),
        nullable=True,
        index=True,
    )
    report_type: Mapped[str] = mapped_column(
        String(50),
        nullable=False,
        index=True,
    )
    ai_provider: Mapped[str] = mapped_column(
        String(50),
        nullable=False,
        server_default="openai",
    )
    # The request body sent by the Flutter client
    input_data: Mapped[dict] = mapped_column(
        JSON,
        nullable=False,
    )
    # The parsed AI response returned to the client
    output_data: Mapped[dict] = mapped_column(
        JSON,
        nullable=False,
    )
    # Optional: store the raw model output for debugging
    raw_output: Mapped[str | None] = mapped_column(
        Text,
        nullable=True,
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        default=_now,
        nullable=False,
        index=True,
    )

    # Many reports → one user
    user: Mapped[User | None] = relationship(
        "User",
        back_populates="reports",
    )

    def __repr__(self) -> str:
        return f"<Report id={self.id} type={self.report_type} provider={self.ai_provider}>"
