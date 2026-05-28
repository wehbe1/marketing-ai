from pydantic import BaseModel, Field, field_validator, model_validator


def _normalize_hashtag_keys(data: object) -> object:
    """Accept legacy AI keys (hashtags_hebrew) and public API keys (hebrew_hashtags)."""
    if not isinstance(data, dict):
        return data

    mapping = {
        "hashtags_hebrew": "hebrew_hashtags",
        "hashtags_english": "english_hashtags",
        "hashtags_trending": "trending_hashtags",
        "hashtags_local": "local_hashtags",
    }
    normalized = dict(data)
    for old_key, new_key in mapping.items():
        if old_key in normalized and new_key not in normalized:
            normalized[new_key] = normalized.pop(old_key)

    nested = normalized.get("hashtags")
    if isinstance(nested, dict):
        normalized["hashtags"] = _normalize_hashtag_keys(nested)

    return normalized


class PostGeneratorInput(BaseModel):
    platform: str
    goal: str
    tone: str
    business: str
    audience: str
    offer: str
    theme: str
    location: str = ""
    language: str = "he"


class HashtagGroups(BaseModel):
    hebrew_hashtags: list[str] = Field(default_factory=list)
    english_hashtags: list[str] = Field(default_factory=list)
    trending_hashtags: list[str] = Field(default_factory=list)
    local_hashtags: list[str] = Field(default_factory=list)

    @model_validator(mode="before")
    @classmethod
    def normalize(cls, data: object) -> object:
        return _normalize_hashtag_keys(data)


class PostGeneratorOutput(BaseModel):
    post: str
    hook: str
    cta: str
    improved_post: str = ""
    business_category: str = ""
    post_objective: str = ""
    hebrew_hashtags: list[str] = Field(default_factory=list)
    english_hashtags: list[str] = Field(default_factory=list)
    trending_hashtags: list[str] = Field(default_factory=list)
    local_hashtags: list[str] = Field(default_factory=list)

    @model_validator(mode="before")
    @classmethod
    def normalize(cls, data: object) -> object:
        data = _normalize_hashtag_keys(data)
        if isinstance(data, dict):
            nested = data.pop("hashtags", None)
            if isinstance(nested, dict):
                nested = HashtagGroups.model_validate(nested)
                data.setdefault("hebrew_hashtags", nested.hebrew_hashtags)
                data.setdefault("english_hashtags", nested.english_hashtags)
                data.setdefault("trending_hashtags", nested.trending_hashtags)
                data.setdefault("local_hashtags", nested.local_hashtags)
        return data


class HashtagAnalysisInput(BaseModel):
    post: str
    hook: str = ""
    cta: str = ""
    business: str
    audience: str
    platform: str
    goal: str
    tone: str
    theme: str
    offer: str = ""
    location: str = ""
    language: str = "he"


class HashtagAnalysisOutput(BaseModel):
    improved_post: str = ""
    business_category: str = ""
    post_objective: str = ""
    hebrew_hashtags: list[str] = Field(default_factory=list)
    english_hashtags: list[str] = Field(default_factory=list)
    trending_hashtags: list[str] = Field(default_factory=list)
    local_hashtags: list[str] = Field(default_factory=list)

    @model_validator(mode="before")
    @classmethod
    def normalize(cls, data: object) -> object:
        return _normalize_hashtag_keys(data)

    @field_validator(
        "hebrew_hashtags",
        "english_hashtags",
        "trending_hashtags",
        "local_hashtags",
        mode="before",
    )
    @classmethod
    def ensure_list(cls, value: object) -> list[str]:
        if value is None:
            return []
        if isinstance(value, list):
            return [str(item).strip() for item in value if str(item).strip()]
        text = str(value).strip()
        return [text] if text else []
