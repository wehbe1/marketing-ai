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
    cors_origins: str = "*"  # comma-separated list in production

    # --- Database (Phase 2) ---
    database_url: str = ""

    # --- Auth (Phase 3) ---
    secret_key: str = "change-me-in-production"
    access_token_expire_minutes: int = 60 * 24  # 24 hours

    model_config = {"env_file": ".env", "env_file_encoding": "utf-8", "extra": "ignore"}


settings = Settings()
