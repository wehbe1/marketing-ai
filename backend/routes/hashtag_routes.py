import logging
from typing import Optional

from fastapi import APIRouter, Query

from models.post_models import HashtagAnalysisInput, HashtagAnalysisOutput
from services.ai_service import AIProvider
from services.hashtag_service import analyze_hashtags as run_hashtag_analysis

logger = logging.getLogger(__name__)

router = APIRouter(tags=["hashtags"])


@router.post("/analyze_hashtags", response_model=HashtagAnalysisOutput)
async def analyze_hashtags(
    payload: HashtagAnalysisInput,
    provider: Optional[AIProvider] = Query(
        None,
        description="AI provider override: 'openai' or 'claude'. Defaults to AI_PROVIDER in .env.",
    ),
):
    """
    Analyze post content and generate categorized hashtag recommendations.

    Primary public endpoint used by the Flutter app.
    """
    return await run_hashtag_analysis(payload, provider=provider)
