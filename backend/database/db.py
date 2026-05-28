"""
Database engine, session management, and declarative base.

Design:
- Uses SQLAlchemy 2.0 async API with asyncpg driver.
- Engine is created lazily: if DATABASE_URL is not set the app still boots
  and all DB-dependent code is simply skipped (see get_db below).
- URL normalisation handles both "postgres://" (Render) and "postgresql://"
  formats by converting them to the "postgresql+asyncpg://" async DSN.
"""
from __future__ import annotations

import logging
from collections.abc import AsyncGenerator
from typing import Optional

from sqlalchemy.ext.asyncio import (
    AsyncEngine,
    AsyncSession,
    async_sessionmaker,
    create_async_engine,
)
from sqlalchemy.orm import DeclarativeBase

from config import settings

logger = logging.getLogger(__name__)

# ---------------------------------------------------------------------------
# Declarative base – shared by all ORM models
# ---------------------------------------------------------------------------

class Base(DeclarativeBase):
    pass


# ---------------------------------------------------------------------------
# Lazy engine + session factory
# ---------------------------------------------------------------------------

_engine: Optional[AsyncEngine] = None
_session_factory: Optional[async_sessionmaker[AsyncSession]] = None


def _normalise_url(url: str) -> str:
    """Convert any postgres:// or postgresql:// URL to the async variant."""
    for prefix in ("postgres://", "postgresql://"):
        if url.startswith(prefix):
            return url.replace(prefix, "postgresql+asyncpg://", 1)
    return url  # already correct (e.g. postgresql+asyncpg://)


def _build_engine() -> AsyncEngine:
    return create_async_engine(
        _normalise_url(settings.database_url),
        echo=settings.app_env == "development",  # SQL logging in dev only
        pool_size=10,
        max_overflow=20,
        pool_pre_ping=True,       # drop stale connections automatically
        pool_recycle=1800,        # recycle connections every 30 min
    )


def get_engine() -> AsyncEngine:
    """Return (and lazily create) the shared async engine."""
    global _engine
    if _engine is None:
        if not settings.database_url:
            raise RuntimeError(
                "DATABASE_URL is not configured. "
                "Add it to your .env file to enable database features."
            )
        _engine = _build_engine()
    return _engine


def get_session_factory() -> async_sessionmaker[AsyncSession]:
    """Return (and lazily create) the session factory."""
    global _session_factory
    if _session_factory is None:
        _session_factory = async_sessionmaker(
            bind=get_engine(),
            class_=AsyncSession,
            expire_on_commit=False,  # safe for async: avoids lazy-load errors
        )
    return _session_factory


# ---------------------------------------------------------------------------
# FastAPI dependency
# ---------------------------------------------------------------------------

async def get_db() -> AsyncGenerator[Optional[AsyncSession], None]:
    """
    Yield an AsyncSession for the request lifetime.

    - Commits on success, rolls back on any exception.
    - Yields None if DATABASE_URL is not configured so that route handlers
      can degrade gracefully without crashing the app.

    Usage in a route:
        async def my_route(db: AsyncSession | None = Depends(get_db)):
            if db is not None:
                ...
    """
    if not settings.database_url:
        yield None
        return

    async with get_session_factory()() as session:
        try:
            yield session
            await session.commit()
        except Exception:
            await session.rollback()
            raise


# ---------------------------------------------------------------------------
# Table management
# ---------------------------------------------------------------------------

async def create_tables() -> None:
    """
    Create all tables that don't exist yet.

    Called once at application startup. Safe to call repeatedly (CREATE IF
    NOT EXISTS semantics). For production use Alembic migrations instead.
    """
    # Models must be imported so their metadata is registered on Base before
    # create_all is called.  The import is local to avoid circular imports.
    import database.models  # noqa: F401

    engine = get_engine()
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    logger.info("Database tables verified / created.")


async def close_engine() -> None:
    """Dispose the engine pool on application shutdown."""
    global _engine
    if _engine is not None:
        await _engine.dispose()
        _engine = None
        logger.info("Database engine closed.")
