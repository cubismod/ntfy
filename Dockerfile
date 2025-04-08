FROM python:3.13.2-bullseye@sha256:0ccfb661016318b3fe76e398d58dc1f409e30601083a8425bb6c1421d3b4f456

WORKDIR /src/app

ARG arch=linux_amd64.deb
ARG ver=2.11.0

RUN python3 -m pip install supervisor

RUN wget https://github.com/binwiederhier/ntfy/releases/download/v${ver}/ntfy_${ver}_${arch}; \
    dpkg -i ntfy_*.deb

RUN apt-get update -y && apt-get upgrade -y && apt-get install -y nginx

COPY ./supervisord.conf ./ 
COPY ./nginx.conf ./
COPY ./server.yml ./

ENV NTFY_AUTH_FILE /ntfy/user.db

CMD [ "supervisord", "-c", "./supervisord.conf" ]
