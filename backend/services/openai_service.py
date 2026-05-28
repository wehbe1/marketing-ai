"""
OpenAI provider implementation.

Uses the OpenAI Responses API (client.responses.create) which was introduced
in openai-python >= 1.66.0. The async client avoids blocking the event loop.
"""
from openai import AsyncOpenAI
from config import settings

_client: AsyncOpenAI | None = None


def _get_client() -> AsyncOpenAI:
    global _client
    if _client is None:
        if not settings.openai_api_key:
            raise RuntimeError("OPENAI_API_KEY is not set in environment.")
        _client = AsyncOpenAI(api_key=settings.openai_api_key)
    return _client


async def generate_text(prompt: str) -> str:
    """Send a prompt to OpenAI and return the text response."""
    client = _get_client()
    response = await client.responses.create(
        model=settings.openai_model,
        input=prompt,
    )
    return response.output_text
