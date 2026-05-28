from typing import Optional

from models.post_models import HashtagAnalysisInput, HashtagAnalysisOutput
from services.ai_service import AIProvider, generate_text
from services.prompt_service import build_hashtag_prompt
from services.report_service import safe_json_load


async def analyze_hashtags(
    payload: HashtagAnalysisInput,
    provider: Optional[AIProvider] = None,
) -> HashtagAnalysisOutput:
    """Run AI hashtag analysis and return normalized output."""
    prompt = build_hashtag_prompt(payload)
    raw_text = await generate_text(prompt, provider=provider)
    data = safe_json_load(raw_text)
    return HashtagAnalysisOutput.model_validate(data)
