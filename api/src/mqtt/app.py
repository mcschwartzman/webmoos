import os
from contextlib import asynccontextmanager

from fastapi_mqtt.config import MQTTConfig
from fastapi_mqtt.fastmqtt import FastMQTT

from .mqtt_ws_client import DynamicMQTTClient

def create_app():

    config = MQTTConfig(host='10.1.0.4')

    fast_mqtt = FastMQTT()