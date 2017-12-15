FROM ubuntu:17.04
MAINTAINER @ashmastaflash


# Versions of things and stuff
ENV HALO_SDK_VERSION=1.0.1
ENV HALO_EVENTS_VERSION=v0.10.4
ENV HALO_SCANS_VERSION=v0.11
ENV FIREWALL_GRAPH_VERSION=v0.1
ENV HALOCELERY_VERSION=v0.3.1

ENV HALO_API_HOSTNAME=api.cloudpassage.com
ENV HALO_API_PORT=443

ENV APP_USER=fieryboat
ENV APP_GROUP=fieryboatgroup

# Package installation
RUN apt-get update && \
    apt-get install -y \
    gcc=4:6.3.0-2ubuntu1 \
    git=1:2.11.0-2 \
    graphviz=2.38.0-16ubuntu1 \
    graphviz-dev=2.38.0-16ubuntu1 \
    linux-headers-generic \
    python=2.7.13-2 \
    python-dev=2.7.13-2 \
    python-pip=9.0.1-2


# Install components from pip
RUN pip install \
    boto3==1.4.3 \
    celery[redis]==4.0.2 \
    cloudpassage==${HALO_SDK_VERSION} \
    docker==2.6.1 \
    flower==0.9.1

RUN pip install \
    pygraphviz==1.4rc1 --install-option="--include-path=/usr/include/graphviz" --install-option="--library-path=/usr/lib/graphviz/"

# Setup for manual library installation
RUN mkdir /src/
WORKDIR /src/

# Install Halo Events library
RUN git clone \
        -b  ${HALO_EVENTS_VERSION} \
        --single-branch \
        https://github.com/cloudpassage/halo-events && \
    cd halo-events && \
    pip install .

# Install Halo Scans library
RUN git clone \
        -b ${HALO_SCANS_VERSION} \
        --single-branch \
        https://github.com/cloudpassage/halo-scans && \
    cd halo-scans && \
    pip install .

# Install Firewall Graph library
RUN git clone \
        -b ${FIREWALL_GRAPH_VERSION} \
        --single-branch \
        https://github.com/cloudpassage-community/firewall-graph && \
    cd firewall-graph && \
    pip install .


# Copy over the app
RUN mkdir /app
WORKDIR /app
RUN git clone \
        -b ${HALOCELERY_VERSION} \
        --single-branch \
        https://github.com/ashmastaflash/halocelery

# Set the user and chown the app
RUN groupadd ${APP_GROUP}

RUN useradd \
        --groups ${APP_GROUP} \
        --shell /bin/sh \
        --home-dir /app \
        ${APP_USER}

RUN chown -R ${APP_USER}:${APP_GROUP} /app

USER ${APP_USER}
