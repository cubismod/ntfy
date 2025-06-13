FROM python:3.13.4-bullseye@sha256:140ecde25459ea6033a3da625056c7dcd76ef5f3567c3893e6c240ac4b0d70a4

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
