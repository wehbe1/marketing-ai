from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import HTMLResponse
from pydantic import BaseModel
from typing import Any, Dict, List, Literal
from dotenv import load_dotenv
from openai import OpenAI
import os
import json
import html as html_lib

# -----------------------------------------------------
# Load ENV + OpenAI Client
# -----------------------------------------------------
load_dotenv()
api_key = os.getenv("OPENAI_API_KEY")
client = OpenAI(api_key=api_key)

# -----------------------------------------------------
# FastAPI + CORS (לחיבור ל-Flutter Web)
# -----------------------------------------------------
app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # אפשר להגביל לדומיינים בסוף
    allow_methods=["*"],
    allow_headers=["*"],
)

# -----------------------------------------------------
#  Helpers ל-HTML
# -----------------------------------------------------
def detect_direction(text: str) -> str:
    """
    מזהה אם הטקסט בעיקר בעברית/ערבית -> RTL, אחרת LTR
    """
    if not text:
        return "rtl"
    for ch in text:
        # Hebrew + Arabic ranges
        if '\u0590' <= ch <= '\u08FF':
            return "rtl"
    return "ltr"


def detect_language_from_fields(payload: Dict[str, Any]) -> str:
    """
    Detects language from payload fields (platform, goal, tone, business, audience, offer, theme).
    Returns "he" for Hebrew, "en" for English.
    """
    fields_to_check = [
        payload.get("platform", ""),
        payload.get("goal", ""),
        payload.get("tone", ""),
        payload.get("business", ""),
        payload.get("audience", ""),
        payload.get("offer", ""),
        payload.get("theme", ""),
    ]
    
    combined_text = " ".join(str(f) for f in fields_to_check)
    
    # Count Hebrew/Arabic characters
    hebrew_count = sum(1 for ch in combined_text if '\u0590' <= ch <= '\u08FF')
    
    # If more than 10% of characters are Hebrew/Arabic, assume Hebrew
    if len(combined_text) > 0 and hebrew_count / len(combined_text) > 0.1:
        return "he"
    return "en"


def _html_escape(text: str) -> str:
    return html_lib.escape(text or "")


def _render_list(items: List[str]) -> str:
    if not items:
        return "<p>-</p>"
    lis = "".join(f"<li>{_html_escape(it)}</li>" for it in items)
    return f"<ul>{lis}</ul>"


def _render_paragraph(label: str, value: str) -> str:
    if not value:
        return ""
    return f"""
      <p><span class="label">{_html_escape(label)}</span> {_html_escape(value)}</p>
    """


# =====================================================
#                MODELS – MARKETING
# =====================================================
class MarketingCase(BaseModel):
    business: Dict[str, Any]
    audience: Dict[str, Any]
    current_marketing: Dict[str, Any]
    goals: Dict[str, Any]
    competition: Dict[str, Any]
    constraints: Dict[str, Any]

    # "new_customers" = לקוחות חדשים
    # "retention"     = שימור לקוחות קיימים
    # "upsell"        = להגדיל סל קנייה / מכירות ללקוחות קיימים
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


# =====================================================
#            MODELS – Post Generator
# =====================================================
class PostGeneratorInput(BaseModel):
    platform: str   # למשל: Instagram, Facebook, WhatsApp
    goal: str       # מטרת הפוסט (engagement, sales וכו')
    tone: str       # friendly, expert, funny...
    business: str   # תיאור העסק/ההצעה בקצרה
    audience: str   # למי מדברים
    offer: str      # מה מציעים בפוסט
    theme: str      # נושא / רעיון מרכזי


class PostGeneratorOutput(BaseModel):
    post: str   # טקסט הפוסט
    hook: str   # פתיח חזק
    cta: str    # קריאת פעולה


# =====================================================
#            PROMPT BUILDER – MARKETING PLAN
# =====================================================
def build_marketing_prompt(case: MarketingCase) -> str:
    marketing_json_str = json.dumps(case.dict(), ensure_ascii=False, indent=2)

    if case.goal_focus == "new_customers":
        focus_instruction = """
GOAL_FOCUS:
- Primary focus: acquiring NEW customers.
- Prioritize channels, messages and weekly actions that bring in people who never bought before.
- Examples: awareness campaigns, reach & impressions, first-purchase offers, traffic to landing page, campaigns to cold audiences.
"""
    elif case.goal_focus == "retention":
        focus_instruction = """
GOAL_FOCUS:
- Primary focus: RETAINING existing customers and increasing their loyalty.
- Prioritize actions that make current customers come back more often and stay longer.
- Examples: WhatsApp/SMS to past buyers, loyalty programs, special offers for returning customers, post-purchase experience, feedback loops.
"""
    elif case.goal_focus == "upsell":
        focus_instruction = """
GOAL_FOCUS:
- Primary focus: increasing REVENUE PER CUSTOMER (UPSELL).
- Prioritize offers and flows that increase order size, frequency, and upgrades.
- Examples: bundles, add-ons, premium versions, cross-sell, subscription plans, "while ordering" suggestions.
"""
    else:
        focus_instruction = """
GOAL_FOCUS:
- No specific focus provided. Build a balanced marketing plan that covers acquisition, retention, and upsell in a realistic way.
"""

    prompt = f"""
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

- NEVER write phrases like:
  "not specified", "missing", "must be decided", "if available", "depends on".

- If information is missing, do NOT mention that it is missing.

- Instead, make a realistic, generic business assumption that fits ANY industry.

Examples of safe defaults:
- Local ad radius: 2–5 km
- Posting frequency: 3 times per week
- Review rating target: 4.7+ with 20–50 reviews
- Starter marketing budget: 1000–3000 ILS/month
- First-time customer offer: 10–15% off or a small bonus item

The final report must feel complete, confident, and actionable.
No placeholders.



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
"""
    return prompt.strip()


# =====================================================
#        PROMPT BUILDER – SINGLE SOCIAL POST
# =====================================================
def build_post_prompt(data: PostGeneratorInput) -> str:
    payload = data.dict()
    business_json = json.dumps(payload, ensure_ascii=False, indent=2)

    # Prefer explicit language if you add it to the model later (recommended)
    lang = payload.get("language")
    if lang not in ("he", "en"):
        lang = detect_language_from_fields(payload)

    language_instruction = (
        "Write the post in HEBREW only."
        if lang == "he"
        else "Write the post in ENGLISH only."
    )

    prompt = f"""
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
  "cta": "string"
}}

INPUT JSON:
{business_json}
""".strip()

    return prompt




# =====================================================
#           HTML REPORT RENDERER
# =====================================================
def render_marketing_html(case: MarketingCase, analysis: MarketingAnalysis) -> str:
    business_name = case.business.get("business_name", "") or ""
    industry = case.business.get("industry", "") or ""
    desc = case.business.get("description", "") or ""

    # כיוון טקסט (RTL לעברית/ערבית)
    base_text_for_direction = business_name or analysis.overall_summary
    direction = detect_direction(base_text_for_direction)
    text_align = "right" if direction == "rtl" else "left"
    lang_attr = "he" if direction == "rtl" else "en"

    goal_focus = case.goal_focus
    goal_focus_str = {
        "new_customers": "מיקוד: גיוס לקוחות חדשים",
        "retention": "מיקוד: שימור לקוחות קיימים",
        "upsell": "מיקוד: הגדלת סל קנייה / Upsell",
    }.get(goal_focus, "מיקוד: משולב")

    # ערוצי שיווק
    channels_rows = ""
    for ch in analysis.recommended_channels:
        channels_rows += f"""
          <tr>
            <td>{_html_escape(ch.channel)}</td>
            <td>{_html_escape(ch.priority.upper())}</td>
            <td>{_html_escape(ch.reason)}</td>
            <td>{_html_escape(ch.suggested_usage)}</td>
          </tr>
        """

    # רעיונות לפוסטים
    post_ideas_html = ""
    for idea in analysis.content_strategy.post_ideas:
        post_ideas_html += f"""
          <div class="card card-sub">
            <h4>{_html_escape(idea.channel)}</h4>
            {_render_paragraph("רעיון:", idea.idea_summary)}
            {_render_paragraph("Hook:", idea.hook)}
            {_render_paragraph("CTA:", idea.call_to_action)}
          </div>
        """

    # תכנית שבועית
    weekly_plan_html = ""
    for idx, week in enumerate(analysis.weekly_plan, start=1):
        actions_html = _render_list(week.actions)
        weekly_plan_html += f"""
          <div class="card card-sub">
            <h4>שבוע {idx}</h4>
            {_render_paragraph("מטרה:", week.week_goal)}
            <h5>צעדים:</h5>
            {actions_html}
          </div>
        """

    strengths_html = _render_list(analysis.strengths)
    weaknesses_html = _render_list(analysis.weaknesses)
    kpis_html = _render_list(analysis.kpis)
    risks_html = _render_list(analysis.risks_and_warnings)

    html = f"""
<!DOCTYPE html>
<html lang="{lang_attr}">
<head>
  <meta charset="utf-8" />
  <title>דוח שיווק חכם - MarketingAI</title>
  <style>
    body {{
      font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
      background-color: #f5f5f7;
      margin: 0;
      padding: 0;
      direction: {direction};
      text-align: {text_align};
    }}
    .page {{
      max-width: 900px;
      margin: 24px auto;
      padding: 24px;
      background-color: #ffffff;
      border-radius: 16px;
      box-shadow: 0 8px 24px rgba(15, 23, 42, 0.08);
    }}
    h1, h2, h3, h4, h5 {{
      margin: 0 0 8px 0;
    }}
    h1 {{
      font-size: 26px;
      color: #111827;
    }}
    h2 {{
      font-size: 20px;
      color: #111827;
      border-bottom: 1px solid #e5e7eb;
      padding-bottom: 4px;
      margin-bottom: 12px;
    }}
    h3 {{
      font-size: 18px;
      color: #111827;
      margin-top: 16px;
    }}
    p {{
      margin: 4px 0;
      color: #374151;
      line-height: 1.5;
    }}
    .label {{
      font-weight: 600;
      color: #111827;
    }}
    .header {{
      display: flex;
      flex-direction: column;
      gap: 4px;
      margin-bottom: 18px;
      padding: 16px;
      border-radius: 12px;
      background: linear-gradient(135deg, #5B8CFF, #9B5BFF);
      color: #ffffff;
    }}
    .header-title {{
      font-size: 22px;
      font-weight: 700;
    }}
    .chip {{
      display: inline-block;
      padding: 4px 10px;
      border-radius: 999px;
      background: rgba(255,255,255,0.12);
      font-size: 13px;
    }}
    .section {{
      margin-top: 24px;
      padding: 16px;
      border-radius: 12px;
      border: 1px solid #e5e7eb;
      background-color: #ffffff;
    }}
    .section-title {{
      font-size: 18px;
      font-weight: 700;
      margin-bottom: 8px;
      color: #111827;
    }}
    ul {{
      margin: 4px 0 4px 0;
      padding-{ 'right' if direction == 'rtl' else 'left' }: 20px;
    }}
    li {{
      margin: 2px 0;
    }}
    .two-columns {{
      display: flex;
      flex-wrap: wrap;
      gap: 16px;
    }}
    .col {{
      flex: 1;
      min-width: 260px;
    }}
    table {{
      width: 100%;
      border-collapse: collapse;
      margin-top: 8px;
      font-size: 13px;
    }}
    th, td {{
      border: 1px solid #e5e7eb;
      padding: 6px 8px;
      vertical-align: top;
    }}
    th {{
      background-color: #eff6ff;
      font-weight: 600;
    }}
    .card {{
      border-radius: 12px;
      border: 1px solid #e5e7eb;
      padding: 12px;
      margin-top: 8px;
      background-color: #fafafa;
    }}
    .card-sub {{
      background-color: #f9fafb;
    }}
    .footer-note {{
      margin-top: 24px;
      font-size: 12px;
      color: #9ca3af;
      text-align: center;
    }}
  </style>
</head>
<body>
  <div class="page">
    <div class="header">
      <div class="header-title">MarketingAI – תוכנית שיווק חכמה</div>
      <div>{_html_escape(business_name)}</div>
      <div>{_html_escape(industry)}</div>
      <div style="font-size: 13px; opacity: 0.9;">{_html_escape(desc)}</div>
      <div style="margin-top: 6px;">
        <span class="chip">{_html_escape(goal_focus_str)}</span>
      </div>
    </div>

    <div class="section">
      <div class="section-title">תקציר מנהלים</div>
      <p>{_html_escape(analysis.overall_summary)}</p>
    </div>

    <div class="section">
      <div class="two-columns">
        <div class="col">
          <div class="section-title">ניתוח קהל יעד</div>
          {_render_paragraph("מי הם:", analysis.audience_analysis.who_they_are)}
          {_render_paragraph("מה הם צריכים:", analysis.audience_analysis.what_they_need)}
          {_render_paragraph("איך לדבר אליהם:", analysis.audience_analysis.how_to_speak_to_them)}
        </div>
        <div class="col">
          <div class="section-title">חוזקות וחולשות</div>
          <h3>חוזקות</h3>
          {strengths_html}
          <h3>חולשות</h3>
          {weaknesses_html}
        </div>
      </div>
    </div>

    <div class="section">
      <div class="section-title">מיתוג ומיצוב</div>
      {_render_paragraph("עמדת המותג:", analysis.positioning.brand_position)}
      {_render_paragraph("הצעת ערך ייחודית:", analysis.positioning.unique_value_proposition)}
      <h3>מסרים מרכזיים</h3>
      {_render_list(analysis.positioning.key_messages)}
    </div>

    <div class="section">
      <div class="section-title">ערוצי שיווק מומלצים</div>
      <table>
        <thead>
          <tr>
            <th>ערוץ</th>
            <th>עדיפות</th>
            <th>למה</th>
            <th>איך להשתמש</th>
          </tr>
        </thead>
        <tbody>
          {channels_rows}
        </tbody>
      </table>
    </div>

    <div class="section">
      <div class="section-title">אסטרטגיית תוכן ורעיונות לפוסטים</div>
      {_render_paragraph("טון דיבור:", analysis.content_strategy.tone_of_voice)}
      <h3>תמות תוכן</h3>
      {_render_list(analysis.content_strategy.content_themes)}
      <h3>רעיונות לפוסטים</h3>
      {post_ideas_html}
    </div>

    <div class="section">
      <div class="section-title">תכנית שבועית</div>
      {weekly_plan_html}
    </div>

    <div class="section">
      <div class="section-title">תקציב, KPI וסיכונים</div>
      {_render_paragraph("המלצת תקציב:", analysis.budget_recommendation)}
      <h3>KPI – מה למדוד</h3>
      {kpis_html}
      <h3>סיכונים ואזהרות</h3>
      {risks_html}
    </div>

    <div class="footer-note">
      דוח נוצר אוטומטית באמצעות MarketingAI.  
      מומלץ לעבור על ההמלצות ולהתאים אותן ידנית למציאות העסקית.
    </div>
  </div>
</body>
</html>
"""
    return html
def safe_json_load(raw_text: str) -> dict:
    """
    Extracts JSON even if the model returns extra text.
    """
    raw_text = raw_text.strip()

    # Find first { and last }
    start = raw_text.find("{")
    end = raw_text.rfind("}")

    if start == -1 or end == -1:
        raise ValueError("Model did not return JSON.")

    json_str = raw_text[start:end+1]
    return json.loads(json_str)



# =====================================================
#                 ENDPOINTS
# =====================================================

# ---- 1. ניתוח שיווק מלא – JSON ----
@app.post("/analyze/marketing", response_model=MarketingAnalysis)
async def analyze_marketing(case: MarketingCase):
    prompt = build_marketing_prompt(case)

    response = client.responses.create(
        model="gpt-5.2",
        input=prompt,
    )

    raw_text = response.output_text
    data = safe_json_load(raw_text)


    return MarketingAnalysis(**data)


# ---- 1b. ניתוח שיווק + HTML ----
@app.post("/analyze/marketing/html")
async def analyze_marketing_html(case: MarketingCase):
    """
    מחזיר דוח HTML מלא, מוכן להדפסה/שמירה כ-PDF מהדפדפן.
    """
    prompt = build_marketing_prompt(case)

    response = client.responses.create(
        model="gpt-5.2",
        input=prompt,
    )

    raw_text = response.output_text
    data = safe_json_load(raw_text)


    analysis = MarketingAnalysis(**data)

    html = render_marketing_html(case, analysis)
    return HTMLResponse(content=html)


# ---- 2. יצירת פוסט בודד ----
@app.post("/post/generate", response_model=PostGeneratorOutput)
async def generate_post(payload: PostGeneratorInput):
    prompt = build_post_prompt(payload)

    response = client.responses.create(
        model="gpt-5.2",
        input=prompt,
    )

    raw_text = response.output_text
    data = safe_json_load(raw_text)


    return PostGeneratorOutput(**data)
