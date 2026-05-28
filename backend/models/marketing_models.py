from pydantic import BaseModel
from typing import Any, Dict, List, Literal


class MarketingCase(BaseModel):
    business: Dict[str, Any]
    audience: Dict[str, Any]
    current_marketing: Dict[str, Any]
    goals: Dict[str, Any]
    competition: Dict[str, Any]
    constraints: Dict[str, Any]
    goal_focus: Literal["new_customers", "retention", "upsell"] = "new_customers"


class RecommendedChannel(BaseModel):
    channel: str
    priority: str
    reason: str
    suggested_usage: str


class PostIdea(BaseModel):
    channel: str
    idea_summary: str
    hook: str
    call_to_action: str


class AudienceAnalysis(BaseModel):
    who_they_are: str
    what_they_need: str
    how_to_speak_to_them: str


class Positioning(BaseModel):
    brand_position: str
    unique_value_proposition: str
    key_messages: List[str]


class ContentStrategy(BaseModel):
    tone_of_voice: str
    content_themes: List[str]
    post_ideas: List[PostIdea]


class WeeklyPlanItem(BaseModel):
    week_goal: str
    actions: List[str]


class MarketingAnalysis(BaseModel):
    overall_summary: str
    strengths: List[str]
    weaknesses: List[str]
    audience_analysis: AudienceAnalysis
    positioning: Positioning
    recommended_channels: List[RecommendedChannel]
    content_strategy: ContentStrategy
    weekly_plan: List[WeeklyPlanItem]
    budget_recommendation: str
    kpis: List[str]
    risks_and_warnings: List[str]
