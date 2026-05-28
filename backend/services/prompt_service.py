"""
Prompt builders for all AI tasks.

Keeping prompts in a dedicated module makes them easy to version,
test, and iterate without touching route or service logic.
"""
import json
from models.marketing_models import MarketingCase
from models.post_models import HashtagAnalysisInput, PostGeneratorInput
from utils.helpers import detect_language_from_fields


def build_marketing_prompt(case: MarketingCase) -> str:
    marketing_json_str = json.dumps(case.model_dump(), ensure_ascii=False, indent=2)

    focus_map = {
        "new_customers": """
GOAL_FOCUS:
- Primary focus: acquiring NEW customers.
- Prioritize channels, messages and weekly actions that bring in people who never bought before.
- Examples: awareness campaigns, reach & impressions, first-purchase offers, traffic to landing page, campaigns to cold audiences.
""",
        "retention": """
GOAL_FOCUS:
- Primary focus: RETAINING existing customers and increasing their loyalty.
- Prioritize actions that make current customers come back more often and stay longer.
- Examples: WhatsApp/SMS to past buyers, loyalty programs, special offers for returning customers, post-purchase experience, feedback loops.
""",
        "upsell": """
GOAL_FOCUS:
- Primary focus: increasing REVENUE PER CUSTOMER (UPSELL).
- Prioritize offers and flows that increase order size, frequency, and upgrades.
- Examples: bundles, add-ons, premium versions, cross-sell, subscription plans, "while ordering" suggestions.
""",
    }
    focus_instruction = focus_map.get(
        case.goal_focus,
        "\nGOAL_FOCUS:\n- No specific focus provided. Build a balanced marketing plan.\n",
    )

    return f"""
You are a senior marketing strategist.

You receive structured JSON describing a business and its current marketing situation.

LANGUAGE RULE:
- Always answer in the SAME language used in the business JSON.
- If the business details are in Hebrew, answer in Hebrew.
- If they are in English, answer in English.
- Do NOT translate the business into another language.

{focus_instruction}

You MUST strongly adapt the plan to this GOAL_FOCUS:
- Channels, messages, content, weekly plan, budget and KPIs should all match this focus.
- If there is a conflict between generic marketing logic and the GOAL_FOCUS, prefer the GOAL_FOCUS.

The input JSON is:

{marketing_json_str}

You must:
- Analyze the business, audience, competition, goals, and constraints.
- Propose a realistic, actionable marketing plan.

COMPLETENESS RULE (CRITICAL):
- NEVER write phrases like: "not specified", "missing", "must be decided", "if available", "depends on".
- If information is missing, do NOT mention that it is missing.
- Instead, make a realistic, generic business assumption that fits ANY industry.

Examples of safe defaults:
- Local ad radius: 2–5 km
- Posting frequency: 3 times per week
- Review rating target: 4.7+ with 20–50 reviews
- Starter marketing budget: 1000–3000 ILS/month
- First-time customer offer: 10–15% off or a small bonus item

The final report must feel complete, confident, and actionable. No placeholders.

Your OUTPUT MUST BE VALID JSON ONLY:

{{
  "overall_summary": string,
  "strengths": string[],
  "weaknesses": string[],
  "audience_analysis": {{
    "who_they_are": string,
    "what_they_need": string,
    "how_to_speak_to_them": string
  }},
  "positioning": {{
    "brand_position": string,
    "unique_value_proposition": string,
    "key_messages": string[]
  }},
  "recommended_channels": [
    {{
      "channel": string,
      "priority": "high" | "medium" | "low",
      "reason": string,
      "suggested_usage": string
    }}
  ],
  "content_strategy": {{
    "tone_of_voice": string,
    "content_themes": string[],
    "post_ideas": [
      {{
        "channel": string,
        "idea_summary": string,
        "hook": string,
        "call_to_action": string
      }}
    ]
  }},
  "weekly_plan": [
    {{
      "week_goal": string,
      "actions": string[]
    }}
  ],
  "budget_recommendation": string,
  "kpis": string[],
  "risks_and_warnings": string[]
}}

Return ONLY this JSON.
""".strip()


def build_post_prompt(data: PostGeneratorInput) -> str:
    payload = data.model_dump()
    business_json = json.dumps(payload, ensure_ascii=False, indent=2)

    lang = payload.get("language")
    if lang not in ("he", "en"):
        lang = detect_language_from_fields(payload)

    language_instruction = (
        "Write the post in HEBREW only."
        if lang == "he"
        else "Write the post in ENGLISH only."
    )

    return f"""
You are a senior social media copywriter.

{language_instruction}

QUALITY RULES:
- Sound confident, complete, and practical.
- Do NOT mention missing information.
- Do NOT use phrases like: "not specified", "missing", "depends on", "if available", "must be decided".
- If a detail is missing, assume a reasonable default and continue.

DEFAULT ASSUMPTIONS (use only when needed, keep generic):
- Local targeting radius: 2–5 km
- Starter budget (if relevant): 1000–3000 ILS/month
- Review goal (if relevant): 4.7+ rating and 20–50 reviews
- First-time offer: 10–15% off OR a small bonus item
- Posting style: short, clear sentences + one strong CTA

TASK:
You will receive structured JSON describing:
- business
- audience
- offer
- platform
- post goal
- tone of voice
- theme

Write ONE social media post that matches the platform, goal, tone, audience, offer, and theme.

OUTPUT FORMAT (STRICT):
Return VALID JSON ONLY (no extra text, no markdown):

{{
  "post": "string",
  "hook": "string",
  "cta": "string",
  "improved_post": "string",
  "business_category": "string",
  "post_objective": "string",
  "hashtags": {{
    "hebrew_hashtags": ["#example"],
    "english_hashtags": ["#Example"],
    "trending_hashtags": ["#Trend"],
    "local_hashtags": ["#City"]
  }}
}}

HASHTAG RULES:
- Generate 5-8 hashtags per category when relevant.
- Each hashtag MUST start with # and contain no spaces.
- hebrew_hashtags: Hebrew hashtags relevant to business and audience.
- english_hashtags: English hashtags for reach and discovery.
- trending_hashtags: trending or high-engagement tags for the platform and topic.
- local_hashtags: location-based tags using city/region from input (or infer from business context).
- improved_post: polish grammar and wording of the post without changing meaning.
- business_category: short label for detected business type.
- post_objective: short label for the post marketing goal.

INPUT JSON:
{business_json}
""".strip()


def build_hashtag_prompt(data: HashtagAnalysisInput) -> str:
    payload = data.model_dump()
    content_json = json.dumps(payload, ensure_ascii=False, indent=2)

    lang = payload.get("language")
    if lang not in ("he", "en"):
        lang = detect_language_from_fields(payload)

    language_note = (
        "UI language is Hebrew — write improved_post in Hebrew."
        if lang == "he"
        else "UI language is English — write improved_post in English."
    )

    return f"""
You are a senior social media strategist specializing in hashtag research and content optimization.

{language_note}

TASK:
Analyze the post content and business context. Then:
1. Fix grammar and wording in improved_post (keep meaning and tone).
2. Detect business_category (e.g. cafe, fitness studio, real estate, ecommerce).
3. Detect post_objective (e.g. engagement, sales, awareness, leads).
4. Generate high-quality hashtags in four separate groups.

HASHTAG ANALYSIS FACTORS:
- Business category and offer
- Target audience
- Location (city/region if provided; otherwise infer from context)
- Post language and platform
- Current social trends for the topic
- Post goal (engagement, sales, awareness)

OUTPUT FORMAT (STRICT):
Return VALID JSON ONLY:

{{
  "improved_post": "string",
  "business_category": "string",
  "post_objective": "string",
  "hebrew_hashtags": ["#tag1", "#tag2"],
  "english_hashtags": ["#Tag1", "#Tag2"],
  "trending_hashtags": ["#Trend1", "#Trend2"],
  "local_hashtags": ["#City1", "#Local1"]
}}

RULES:
- 5-8 hashtags per category when relevant; empty array only if truly not applicable.
- Every hashtag MUST start with # and contain no spaces.
- hebrew_hashtags: Hebrew tags only.
- english_hashtags: English tags only.
- trending_hashtags: mix allowed if commonly used on the platform.
- local_hashtags: location/city/neighborhood tags.

INPUT JSON:
{content_json}
""".strip()
