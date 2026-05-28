"""
Report history endpoints — all require authentication.

GET /reports              — paginated list of the current user's reports
GET /reports/{report_id}  — single report detail (must belong to the user)
"""
from __future__ import annotations

import uuid
from typing import Optional

from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.ext.asyncio import AsyncSession

from database.crud import get_report, list_reports
from database.db import get_db
from database.models import ReportType, User
from dependencies import get_current_user

router = APIRouter(prefix="/reports", tags=["reports"])


@router.get("", summary="List your generated reports")
async def get_reports(
    report_type: Optional[ReportType] = Query(
        None,
        description="Filter by type: 'marketing' or 'post'.",
    ),
    limit: int = Query(20, ge=1, le=100),
    offset: int = Query(0, ge=0),
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """
    Return the authenticated user's report history, newest first.
    Supports pagination via ``limit`` and ``offset`` query params.
    """
    reports = await list_reports(
        db=db,
        user_id=current_user.id,
        report_type=report_type,
        limit=limit,
        offset=offset,
    )
    return {
        "total": len(reports),
        "limit": limit,
        "offset": offset,
        "items": [_serialize_report(r) for r in reports],
    }


@router.get("/{report_id}", summary="Get a single report by ID")
async def get_report_detail(
    report_id: uuid.UUID,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """
    Return the full input + output data for a single report.
    Returns 404 if the report doesn't exist or belongs to another user.
    """
    report = await get_report(db, report_id)

    if report is None or report.user_id != current_user.id:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Report not found.",
        )

    return _serialize_report(report, include_raw=True)


# ---------------------------------------------------------------------------
# Internal serialiser — avoids creating a full Pydantic schema for the
# report's dynamic JSON fields while still controlling what is exposed.
# ---------------------------------------------------------------------------

def _serialize_report(report, *, include_raw: bool = False) -> dict:
    data = {
        "id": str(report.id),
        "report_type": report.report_type.value,
        "ai_provider": report.ai_provider,
        "input_data": report.input_data,
        "output_data": report.output_data,
        "created_at": report.created_at.isoformat(),
    }
    if include_raw and report.raw_output:
        data["raw_output"] = report.raw_output
    return data
