FROM ubuntu

WORKDIR /app

COPY . /app

RUN chmod +x initiate.sh && ./initiate.sh
