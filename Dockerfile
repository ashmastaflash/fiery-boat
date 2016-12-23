FROM alpine:3.4
MAINTAINER @ashmastaflash

RUN apk add -U \
    python \
    py-pip

RUN pip install \
    celery \
    flower

COPY app/ /app

WORKDIR /app
