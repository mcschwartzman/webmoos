FROM mcschwartzman/moos-ivp-base:latest

COPY ./moos-ivp-mcschwar /git/moos-ivp-mcschwar

RUN cd /git/moos-ivp-mcschwar \
    && ./build.sh

ENV PATH="$PATH:/git/moos-ivp-mcschwar/bin"

COPY ./missions /missions
COPY ./docker_2680.sh /docker_2680.sh
COPY ./docker_entrypoint.sh /docker_entrypoint.sh

WORKDIR /git/moos-ivp-2680/missions/lab_14_rescue_baseline

CMD [ "bash", "/docker_2680.sh" ]
