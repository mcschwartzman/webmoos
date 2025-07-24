FROM mcschwartzman/moos-ivp-base:latest

COPY ./missions /missions
COPY ./docker_entrypoint.sh docker_entrypoint.sh

WORKDIR /git

COPY ./moos-ivp-mcschwar /moos-ivp-mcschwar

RUN cd /git/moos-ivp-mcschwar \
    && ./build.sh

WORKDIR /community/missions/swimmer_rescue

CMD [ "bash", "/docker_2680.sh" ]