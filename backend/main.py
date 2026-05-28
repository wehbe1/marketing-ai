import logging
from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from config import get_cors_origins, settings
from utils.firebase_auth import is_firebase_configured

logger = logging.getLogger(__name__)


# ---------------------------------------------------------------------------
# Lifespan: startup + shutdown hooks
# ---------------------------------------------------------------------------

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup
    if settings.database_url:
        from database.db import create_tables, run_startup_migrations
        await create_tables()
        await run_startup_migrations()
    else:
        logger.warning(
            "DATABASE_URL is not set — database features are disabled. "
            "Add DATABASE_URL to .env to enable persistence and auth."
        )
    yield
    # Shutdown
    if settings.database_url:
        from database.db import close_engine
        await close_engine()


# ---------------------------------------------------------------------------
# App
# ---------------------------------------------------------------------------

app = FastAPI(
    title="Marketing AI API",
    description="AI-powered marketing plan and social post generator.",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc",
    lifespan=lifespan,
)

# CORS — set FRONTEND_URL and/or CORS_ORIGINS in production.
origins = get_cors_origins()

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ---------------------------------------------------------------------------
# Routers
# ---------------------------------------------------------------------------

from routes.auth_routes import router as auth_router          # noqa: E402
from routes.hashtag_routes import router as hashtag_router    # noqa: E402
from routes.marketing_routes import router as marketing_router  # noqa: E402
from routes.post_routes import router as post_router          # noqa: E402
from routes.reports_routes import router as reports_router    # noqa: E402

app.include_router(auth_router)
app.include_router(hashtag_router)
app.include_router(marketing_router)
app.include_router(post_router)
app.include_router(reports_router)


# ---------------------------------------------------------------------------
# Health check
# ---------------------------------------------------------------------------

@app.get("/health", tags=["meta"])
async def health_check():
    db_status = "disabled"
    if settings.database_url:
        try:
            from database.db import get_engine
            from sqlalchemy import text
            async with get_engine().connect() as conn:
                await conn.execute(text("SELECT 1"))
            db_status = "ok"
        except Exception as exc:
            db_status = f"error: {exc}"

    return {
        "status": "ok",
        "env": settings.app_env,
        "database": db_status,
        "firebase": "configured" if is_firebase_configured() else "disabled",
        "auth": "firebase",
        "ai_provider": settings.ai_provider,
    }
