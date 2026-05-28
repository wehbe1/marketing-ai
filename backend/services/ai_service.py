"""
AI provider abstraction layer.

This is the single entry point for all AI text generation in the app.
Routes to the correct provider (OpenAI or Claude) based on the caller's
preference or the global AI_PROVIDER setting in .env.

Usage:
    from services.ai_service import generate_text, AIProvider

    # Use the default provider configured in .env
    result = await generate_text(prompt)

    # Explicitly choose a provider per-request
    result = await generate_text(prompt, provider=AIProvider.CLAUDE)
"""
from enum import Enum
from typing import Optional

from config import settings
import services.openai_service as openai_svc
import services.claude_service as claude_svc


class AIProvider(str, Enum):
    OPENAI = "openai"
    CLAUDE = "claude"


async def generate_text(
    prompt: str,
    provider: Optional[AIProvider] = None,
) -> str:
    """
    Generate text from the specified (or default) AI provider.

    Args:
        prompt:   The full prompt string to send.
        provider: Override the global default. If None, uses AI_PROVIDER from .env.

    Returns:
        The model's text response as a plain string.

    Raises:
        RuntimeError: If the required API key for the chosen provider is missing.
        ValueError:   If an unknown provider is specified.
    """
    effective = provider or AIProvider(settings.ai_provider)

    if effective == AIProvider.OPENAI:
        return await openai_svc.generate_text(prompt)

    if effective == AIProvider.CLAUDE:
        return await claude_svc.generate_text(prompt)

    raise ValueError(f"Unknown AI provider: '{effective}'. Valid values: openai, claude.")
