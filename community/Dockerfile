ARG BASE_IMAGE=cbenj27/moos-ivp-base:latest
FROM ${BASE_IMAGE}

COPY ./missions /missions
COPY ./docker_entrypoint.sh docker_entrypoint.sh

WORKDIR /git

COPY ./docker_2680.sh /docker_2680.sh
COPY ./docker_entrypoint.sh /docker_entrypoint.sh
COPY --from=artifacts /bin /opt/webmoos-extend/bin
COPY --from=artifacts /lib /opt/webmoos-extend/lib

WORKDIR /community/missions/swimmer_rescue

CMD [ "bash", "/docker_entrypoint.sh" ]
