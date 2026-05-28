"""
HTML report renderer and JSON utilities.

Converts a MarketingAnalysis + MarketingCase into a styled HTML report
that can be displayed in a browser or converted to PDF on the client.
"""
import json
from models.marketing_models import MarketingCase, MarketingAnalysis
from utils.helpers import detect_direction, html_escape, render_list, render_paragraph


def safe_json_load(raw_text: str) -> dict:
    """
    Extracts a JSON object from the model's raw output.
    Handles cases where the model wraps JSON in markdown fences or adds text.
    """
    raw_text = raw_text.strip()
    start = raw_text.find("{")
    end = raw_text.rfind("}")
    if start == -1 or end == -1:
        raise ValueError("Model did not return valid JSON.")
    return json.loads(raw_text[start : end + 1])


def render_marketing_html(case: MarketingCase, analysis: MarketingAnalysis) -> str:
    business_name = case.business.get("business_name", "") or ""
    industry = case.business.get("industry", "") or ""
    desc = case.business.get("description", "") or ""

    direction = detect_direction(business_name or analysis.overall_summary)
    text_align = "right" if direction == "rtl" else "left"
    lang_attr = "he" if direction == "rtl" else "en"
    padding_side = "right" if direction == "rtl" else "left"

    goal_focus_labels = {
        "new_customers": "מיקוד: גיוס לקוחות חדשים",
        "retention": "מיקוד: שימור לקוחות קיימים",
        "upsell": "מיקוד: הגדלת סל קנייה / Upsell",
    }
    goal_focus_str = goal_focus_labels.get(case.goal_focus, "מיקוד: משולב")

    channels_rows = "".join(
        f"""
        <tr>
          <td>{html_escape(ch.channel)}</td>
          <td>{html_escape(ch.priority.upper())}</td>
          <td>{html_escape(ch.reason)}</td>
          <td>{html_escape(ch.suggested_usage)}</td>
        </tr>
        """
        for ch in analysis.recommended_channels
    )

    post_ideas_html = "".join(
        f"""
        <div class="card card-sub">
          <h4>{html_escape(idea.channel)}</h4>
          {render_paragraph("רעיון:", idea.idea_summary)}
          {render_paragraph("Hook:", idea.hook)}
          {render_paragraph("CTA:", idea.call_to_action)}
        </div>
        """
        for idea in analysis.content_strategy.post_ideas
    )

    weekly_plan_html = "".join(
        f"""
        <div class="card card-sub">
          <h4>שבוע {idx}</h4>
          {render_paragraph("מטרה:", week.week_goal)}
          <h5>צעדים:</h5>
          {render_list(week.actions)}
        </div>
        """
        for idx, week in enumerate(analysis.weekly_plan, start=1)
    )

    return f"""<!DOCTYPE html>
<html lang="{lang_attr}">
<head>
  <meta charset="utf-8" />
  <title>דוח שיווק חכם - MarketingAI</title>
  <style>
    body {{
      font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
      background-color: #f5f5f7;
      margin: 0; padding: 0;
      direction: {direction};
      text-align: {text_align};
    }}
    .page {{ max-width: 900px; margin: 24px auto; padding: 24px;
      background: #fff; border-radius: 16px;
      box-shadow: 0 8px 24px rgba(15,23,42,0.08); }}
    h1,h2,h3,h4,h5 {{ margin: 0 0 8px 0; }}
    h1 {{ font-size: 26px; color: #111827; }}
    h2 {{ font-size: 20px; color: #111827; border-bottom: 1px solid #e5e7eb;
      padding-bottom: 4px; margin-bottom: 12px; }}
    h3 {{ font-size: 18px; color: #111827; margin-top: 16px; }}
    p {{ margin: 4px 0; color: #374151; line-height: 1.5; }}
    .label {{ font-weight: 600; color: #111827; }}
    .header {{ display: flex; flex-direction: column; gap: 4px;
      margin-bottom: 18px; padding: 16px; border-radius: 12px;
      background: linear-gradient(135deg, #5B8CFF, #9B5BFF); color: #fff; }}
    .header-title {{ font-size: 22px; font-weight: 700; }}
    .chip {{ display: inline-block; padding: 4px 10px; border-radius: 999px;
      background: rgba(255,255,255,0.12); font-size: 13px; }}
    .section {{ margin-top: 24px; padding: 16px; border-radius: 12px;
      border: 1px solid #e5e7eb; background: #fff; }}
    .section-title {{ font-size: 18px; font-weight: 700; margin-bottom: 8px; color: #111827; }}
    ul {{ margin: 4px 0; padding-{padding_side}: 20px; }}
    li {{ margin: 2px 0; }}
    .two-columns {{ display: flex; flex-wrap: wrap; gap: 16px; }}
    .col {{ flex: 1; min-width: 260px; }}
    table {{ width: 100%; border-collapse: collapse; margin-top: 8px; font-size: 13px; }}
    th, td {{ border: 1px solid #e5e7eb; padding: 6px 8px; vertical-align: top; }}
    th {{ background: #eff6ff; font-weight: 600; }}
    .card {{ border-radius: 12px; border: 1px solid #e5e7eb;
      padding: 12px; margin-top: 8px; background: #fafafa; }}
    .card-sub {{ background: #f9fafb; }}
    .footer-note {{ margin-top: 24px; font-size: 12px; color: #9ca3af; text-align: center; }}
  </style>
</head>
<body>
  <div class="page">
    <div class="header">
      <div class="header-title">MarketingAI – תוכנית שיווק חכמה</div>
      <div>{html_escape(business_name)}</div>
      <div>{html_escape(industry)}</div>
      <div style="font-size:13px;opacity:0.9;">{html_escape(desc)}</div>
      <div style="margin-top:6px;"><span class="chip">{html_escape(goal_focus_str)}</span></div>
    </div>

    <div class="section">
      <div class="section-title">תקציר מנהלים</div>
      <p>{html_escape(analysis.overall_summary)}</p>
    </div>

    <div class="section">
      <div class="two-columns">
        <div class="col">
          <div class="section-title">ניתוח קהל יעד</div>
          {render_paragraph("מי הם:", analysis.audience_analysis.who_they_are)}
          {render_paragraph("מה הם צריכים:", analysis.audience_analysis.what_they_need)}
          {render_paragraph("איך לדבר אליהם:", analysis.audience_analysis.how_to_speak_to_them)}
        </div>
        <div class="col">
          <div class="section-title">חוזקות וחולשות</div>
          <h3>חוזקות</h3>{render_list(analysis.strengths)}
          <h3>חולשות</h3>{render_list(analysis.weaknesses)}
        </div>
      </div>
    </div>

    <div class="section">
      <div class="section-title">מיתוג ומיצוב</div>
      {render_paragraph("עמדת המותג:", analysis.positioning.brand_position)}
      {render_paragraph("הצעת ערך ייחודית:", analysis.positioning.unique_value_proposition)}
      <h3>מסרים מרכזיים</h3>{render_list(analysis.positioning.key_messages)}
    </div>

    <div class="section">
      <div class="section-title">ערוצי שיווק מומלצים</div>
      <table>
        <thead>
          <tr><th>ערוץ</th><th>עדיפות</th><th>למה</th><th>איך להשתמש</th></tr>
        </thead>
        <tbody>{channels_rows}</tbody>
      </table>
    </div>

    <div class="section">
      <div class="section-title">אסטרטגיית תוכן ורעיונות לפוסטים</div>
      {render_paragraph("טון דיבור:", analysis.content_strategy.tone_of_voice)}
      <h3>תמות תוכן</h3>{render_list(analysis.content_strategy.content_themes)}
      <h3>רעיונות לפוסטים</h3>{post_ideas_html}
    </div>

    <div class="section">
      <div class="section-title">תכנית שבועית</div>
      {weekly_plan_html}
    </div>

    <div class="section">
      <div class="section-title">תקציב, KPI וסיכונים</div>
      {render_paragraph("המלצת תקציב:", analysis.budget_recommendation)}
      <h3>KPI – מה למדוד</h3>{render_list(analysis.kpis)}
      <h3>סיכונים ואזהרות</h3>{render_list(analysis.risks_and_warnings)}
    </div>

    <div class="footer-note">
      דוח נוצר אוטומטית באמצעות MarketingAI.<br>
      מומלץ לעבור על ההמלצות ולהתאים אותן ידנית למציאות העסקית.
    </div>
  </div>
</body>
</html>"""
