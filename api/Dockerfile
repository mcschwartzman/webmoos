FROM mcschwartzman/moos-ivp-base:latest

RUN apt install python3-pip -y \
    && pip install fastapi[standard] \
    && mkdir -p api/src

COPY ./src /api/src

WORKDIR /api/src

CMD ["fastapi", "run", "main.py"]