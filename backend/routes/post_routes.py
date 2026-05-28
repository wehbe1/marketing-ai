import logging
from typing import Optional

from fastapi import APIRouter, Depends, Query
from sqlalchemy.ext.asyncio import AsyncSession

from database.crud import save_report
from database.db import get_db
from database.models import ReportType, User
from dependencies import get_optional_user
from models.post_models import (
    HashtagAnalysisInput,
    HashtagAnalysisOutput,
    PostGeneratorInput,
    PostGeneratorOutput,
)
from services.ai_service import AIProvider, generate_text
from services.hashtag_service import analyze_hashtags as run_hashtag_analysis
from services.prompt_service import build_post_prompt
from services.report_service import safe_json_load

logger = logging.getLogger(__name__)
router = APIRouter(prefix="/post", tags=["posts"])


@router.post("/generate", response_model=PostGeneratorOutput)
async def generate_post(
    payload: PostGeneratorInput,
    provider: Optional[AIProvider] = Query(
        None,
        description="AI provider override: 'openai' or 'claude'. Defaults to AI_PROVIDER in .env.",
    ),
    db: Optional[AsyncSession] = Depends(get_db),
    current_user: Optional[User] = Depends(get_optional_user),
):
    """
    Generate a single social media post (text, hook, CTA, hashtags).

    - Works for anonymous and authenticated users.
    - When authenticated, the post is saved and linked to the user's account.
    """
    prompt = build_post_prompt(payload)
    raw_text = await generate_text(prompt, provider=provider)
    data = safe_json_load(raw_text)
    output = PostGeneratorOutput.model_validate(data)

    if db is not None:
        try:
            await save_report(
                db=db,
                report_type=ReportType.POST,
                ai_provider=(provider.value if provider else "openai"),
                input_data=payload.model_dump(),
                output_data=output.model_dump(),
                raw_output=raw_text,
                user_id=current_user.id if current_user else None,
            )
        except Exception:
            logger.exception("Failed to save post report — continuing.")

    return output


@router.post("/hashtags/analyze", response_model=HashtagAnalysisOutput)
async def analyze_hashtags_legacy(
    payload: HashtagAnalysisInput,
    provider: Optional[AIProvider] = Query(
        None,
        description="AI provider override: 'openai' or 'claude'. Defaults to AI_PROVIDER in .env.",
    ),
):
    """Legacy alias — prefer POST /analyze_hashtags."""
    return await run_hashtag_analysis(payload, provider=provider)
