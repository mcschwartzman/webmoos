ARG BASE_IMAGE=mcschwartzman/moos-ivp-base-arm:latest
FROM ${BASE_IMAGE}

COPY ./missions /missions
COPY ./docker_entrypoint.sh docker_entrypoint.sh

WORKDIR /git

COPY ./moos-ivp-mcschwar /git/moos-ivp-mcschwar
COPY ./docker_2680.sh /docker_2680.sh
COPY ./docker_entrypoint.sh /docker_entrypoint.sh

RUN cd /git/moos-ivp-mcschwar \
    && ./build.sh

ENV PATH="$PATH:/git/moos-ivp-mcschwar/bin"

WORKDIR /community/missions/swimmer_rescue

CMD [ "bash", "/docker_entrypoint.sh" ]
