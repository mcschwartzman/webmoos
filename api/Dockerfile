FROM mcschwartzman/moos-ivp-base:latest

RUN apt install python3-pip -y \
    && pip install fastapi[standard] \
    && pip install fastapi-mqtt \
    && pip install websockets \
    && pip install "paho-mqtt<1.9" \
    && pip install pydantic-settings \
    && mkdir -p api/src \
    && mkdir -p api/config

COPY ./src /api/src
COPY ./config /api/config

WORKDIR /api/src

CMD ["fastapi", "run", "main.py"]