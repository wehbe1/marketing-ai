from pydantic import BaseModel


class PostGeneratorInput(BaseModel):
    platform: str
    goal: str
    tone: str
    business: str
    audience: str
    offer: str
    theme: str


class PostGeneratorOutput(BaseModel):
    post: str
    hook: str
    cta: str
