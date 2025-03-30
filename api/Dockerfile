FROM mcschwartzman/moos-ivp-base:latest

RUN apt install python3-pip -y \
    && pip install fastapi[standard] \
    && pip install fastapi-mqtt \
    && pip install websockets \
    && pip install "paho-mqtt<1.9" \
    && mkdir -p api/src

COPY ./src /api/src

WORKDIR /api/src

CMD ["fastapi", "run", "main.py"]