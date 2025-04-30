from fastapi import FastAPI
from .moos_client import MoosClient
from .moosvar import MoosVar

from config.app_settings import *

settings = Settings()
app = FastAPI()

address = settings.autonomy_address
port = settings.autonomy_port

client = MoosClient(address, port)

@app.get("/")
def read_root():
    return {"Hello": "World"}

@app.post("/post-moosvar")
def post_moosvar(moosvar: MoosVar):

    var_dict = moosvar.dict()

    name = var_dict['name']
    value = var_dict['value']

    client.notify(name, value, -1)

    return {"posted_var": name}