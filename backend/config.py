from pydantic_settings import BaseSettings
from typing import Literal


class Settings(BaseSettings):
    # --- AI Providers ---
    openai_api_key: str = ""
    anthropic_api_key: str = ""

    # Which provider to use by default: "openai" | "claude"
    ai_provider: Literal["openai", "claude"] = "openai"

    # Model names — override in .env to pin a specific version
    openai_model: str = "gpt-5.2"
    claude_model: str = "claude-sonnet-4-5"

    # --- App ---
    app_env: Literal["development", "production"] = "development"
    # Primary deployed frontend URL (e.g. https://your-app.web.app)
    frontend_url: str = ""
    # Additional allowed origins, comma-separated
    cors_origins: str = "*"

    # --- Database (Phase 2) ---
    database_url: str = ""

    # --- Auth (legacy JWT) ---
    secret_key: str = "change-me-in-production"
    access_token_expire_minutes: int = 60 * 24  # 24 hours

    # --- Auth (Firebase) ---
    firebase_project_id: str = ""
    # Paste the full service-account JSON on Render, or use a local file path.
    firebase_credentials_json: str = ""
    firebase_credentials_path: str = ""

    model_config = {"env_file": ".env", "env_file_encoding": "utf-8", "extra": "ignore"}


settings = Settings()


def get_cors_origins() -> list[str]:
    """Build the CORS allow-list from FRONTEND_URL and CORS_ORIGINS."""
    origins: list[str] = []

    if settings.frontend_url.strip():
        origins.append(settings.frontend_url.strip().rstrip("/"))

    if settings.cors_origins.strip() and settings.cors_origins.strip() != "*":
        origins.extend(
            origin.strip().rstrip("/")
            for origin in settings.cors_origins.split(",")
            if origin.strip()
        )

    if not origins:
        return ["*"]

    # De-duplicate while preserving order
    seen: set[str] = set()
    unique: list[str] = []
    for origin in origins:
        if origin not in seen:
            seen.add(origin)
            unique.append(origin)
    return unique
