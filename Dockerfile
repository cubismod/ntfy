FROM python:3.13.5-bullseye@sha256:7ab8844f3427d44da3eec7f63a078cc6bf60127bb632418e1fad18569199a25d

WORKDIR /src/app

ARG arch=linux_amd64.deb
ARG ver=2.12.0

RUN python3 -m pip install supervisor

RUN wget https://github.com/binwiederhier/ntfy/releases/download/v${ver}/ntfy_${ver}_${arch}; \
    dpkg -i ntfy_*.deb

RUN apt-get update -y && apt-get upgrade -y && apt-get install -y nginx

COPY ./supervisord.conf ./ 
COPY ./nginx.conf ./
COPY ./server.yml ./

ENV NTFY_AUTH_FILE /ntfy/user.db

CMD [ "supervisord", "-c", "./supervisord.conf" ]
