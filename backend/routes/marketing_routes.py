import logging
from typing import Optional

from fastapi import APIRouter, Depends, Query
from fastapi.responses import HTMLResponse
from sqlalchemy.ext.asyncio import AsyncSession

from database.crud import save_report
from database.db import get_db
from database.models import ReportType, User
from dependencies import get_optional_user
from models.marketing_models import MarketingAnalysis, MarketingCase
from services.ai_service import AIProvider, generate_text
from services.prompt_service import build_marketing_prompt
from services.report_service import render_marketing_html, safe_json_load

logger = logging.getLogger(__name__)
router = APIRouter(prefix="/analyze", tags=["marketing"])


@router.post("/marketing", response_model=MarketingAnalysis)
async def analyze_marketing(
    case: MarketingCase,
    provider: Optional[AIProvider] = Query(
        None,
        description="AI provider override: 'openai' or 'claude'. Defaults to AI_PROVIDER in .env.",
    ),
    db: Optional[AsyncSession] = Depends(get_db),
    current_user: Optional[User] = Depends(get_optional_user),
):
    """
    Generate a full marketing analysis as structured JSON.

    - Works for anonymous and authenticated users.
    - When authenticated, the report is saved and linked to the user's account.
    """
    prompt = build_marketing_prompt(case)
    raw_text = await generate_text(prompt, provider=provider)
    data = safe_json_load(raw_text)
    analysis = MarketingAnalysis(**data)

    if db is not None:
        try:
            await save_report(
                db=db,
                report_type=ReportType.MARKETING,
                ai_provider=(provider.value if provider else "openai"),
                input_data=case.model_dump(),
                output_data=data,
                raw_output=raw_text,
                user_id=current_user.id if current_user else None,
            )
        except Exception:
            logger.exception("Failed to save marketing report — continuing.")

    return analysis


@router.post("/marketing/html", response_class=HTMLResponse)
async def analyze_marketing_html(
    case: MarketingCase,
    provider: Optional[AIProvider] = Query(
        None,
        description="AI provider override: 'openai' or 'claude'. Defaults to AI_PROVIDER in .env.",
    ),
    db: Optional[AsyncSession] = Depends(get_db),
    current_user: Optional[User] = Depends(get_optional_user),
):
    """
    Generate a full marketing analysis and return a styled HTML report.
    Ready for printing or browser-to-PDF conversion.
    """
    prompt = build_marketing_prompt(case)
    raw_text = await generate_text(prompt, provider=provider)
    data = safe_json_load(raw_text)
    analysis = MarketingAnalysis(**data)

    if db is not None:
        try:
            await save_report(
                db=db,
                report_type=ReportType.MARKETING,
                ai_provider=(provider.value if provider else "openai"),
                input_data=case.model_dump(),
                output_data=data,
                raw_output=raw_text,
                user_id=current_user.id if current_user else None,
            )
        except Exception:
            logger.exception("Failed to save marketing HTML report — continuing.")

    return HTMLResponse(content=render_marketing_html(case, analysis))
