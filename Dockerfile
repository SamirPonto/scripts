FROM ubuntu

ENV XDG_CONFIG_HOME=/root/.config

WORKDIR /app

COPY . /app

RUN chmod +x initiate.sh && ./initiate.sh
