"""
Anthropic Claude provider implementation.

Uses the Messages API via the official anthropic-python SDK.
The async client avoids blocking the event loop.
"""
from anthropic import AsyncAnthropic
from config import settings

_client: AsyncAnthropic | None = None


def _get_client() -> AsyncAnthropic:
    global _client
    if _client is None:
        if not settings.anthropic_api_key:
            raise RuntimeError("ANTHROPIC_API_KEY is not set in environment.")
        _client = AsyncAnthropic(api_key=settings.anthropic_api_key)
    return _client


async def generate_text(prompt: str) -> str:
    """Send a prompt to Claude and return the text response."""
    client = _get_client()
    message = await client.messages.create(
        model=settings.claude_model,
        max_tokens=4096,
        messages=[{"role": "user", "content": prompt}],
    )
    return message.content[0].text
