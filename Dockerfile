FROM python:3.13.2-bullseye@sha256:d39941100ed3e07de595290be59314dffcb27bda7be781eb849b674495a0f997

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
