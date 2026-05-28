import html as html_lib
from typing import Any, Dict, List


def detect_direction(text: str) -> str:
    """Returns 'rtl' if the text is primarily Hebrew/Arabic, else 'ltr'."""
    if not text:
        return "rtl"
    for ch in text:
        if "\u0590" <= ch <= "\u08FF":
            return "rtl"
    return "ltr"


def detect_language_from_fields(payload: Dict[str, Any]) -> str:
    """
    Infers language from common post/marketing payload fields.
    Returns 'he' for Hebrew/Arabic-heavy content, 'en' otherwise.
    """
    fields = [
        payload.get("platform", ""),
        payload.get("goal", ""),
        payload.get("tone", ""),
        payload.get("business", ""),
        payload.get("audience", ""),
        payload.get("offer", ""),
        payload.get("theme", ""),
    ]
    combined = " ".join(str(f) for f in fields)
    hebrew_count = sum(1 for ch in combined if "\u0590" <= ch <= "\u08FF")
    if len(combined) > 0 and hebrew_count / len(combined) > 0.1:
        return "he"
    return "en"


def html_escape(text: str) -> str:
    return html_lib.escape(text or "")


def render_list(items: List[str]) -> str:
    if not items:
        return "<p>-</p>"
    lis = "".join(f"<li>{html_escape(it)}</li>" for it in items)
    return f"<ul>{lis}</ul>"


def render_paragraph(label: str, value: str) -> str:
    if not value:
        return ""
    return f'<p><span class="label">{html_escape(label)}</span> {html_escape(value)}</p>'
