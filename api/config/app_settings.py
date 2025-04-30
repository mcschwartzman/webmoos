from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    autonomy_address: str = "10.1.0.2"
    autonomy_port: int = 9000
