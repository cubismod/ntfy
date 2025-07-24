FROM python:3.13.5-bullseye@sha256:f3b936f3ecc6907d7778cee3c36728e64d3542c577fd9f6c76ee563d904a9109

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
