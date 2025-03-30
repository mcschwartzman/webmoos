from pydantic import BaseModel

class MoosVar(BaseModel):
    name: str
    value: str