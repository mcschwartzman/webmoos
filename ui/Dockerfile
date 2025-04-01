FROM node:18.20.8-bullseye

RUN mkdir public

COPY ./public /public
COPY ./index.js index.js
COPY ./jsconfig.json jsconfig.json
COPY ./package.json package.json
COPY ./docker_entrypoint.sh docker_entrypoint.sh

RUN npm install

CMD ["/bin/bash", "/docker_entrypoint.sh"]