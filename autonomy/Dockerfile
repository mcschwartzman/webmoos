FROM mcschwartzman/moos-ivp-base:latest

COPY ./missions /missions
COPY ./docker_entrypoint.sh docker_entrypoint.sh

WORKDIR /missions/henry_gilda_baseline

CMD [ "bash", "/docker_entrypoint.sh" ]
