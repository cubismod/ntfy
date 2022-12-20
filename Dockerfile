FROM python:3.11.1-bullseye

WORKDIR /src/app

ARG arch=linux_amd64.deb

RUN python3 -m pip install supervisor

RUN wget https://github.com/binwiederhier/ntfy/releases/download/v1.29.1/ntfy_1.29.1_${arch}; \
    dpkg -i ntfy_*.deb

RUN apt-get update -y && apt-get upgrade -y && apt-get install -y nginx

COPY ./supervisord.conf ./ 
COPY ./nginx.conf ./
COPY ./server.yml ./

ENV NTFY_AUTH_FILE /ntfy/user.db

CMD [ "supervisord", "-c", "./supervisord.conf" ]
