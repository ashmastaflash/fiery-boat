FROM ubuntu:17.04
MAINTAINER @ashmastaflash


# Versions of things and stuff
ENV HALO_SDK_VERSION=1.0.1
ENV HALO_EVENTS_VERSION=v0.10.2
ENV HALO_SCANS_VERSION=v0.11
ENV FIREWALL_GRAPH_VERSION=v0.1
ENV SCAN_GRAPH_VERSION=v0.1.1

ENV HALO_API_HOSTNAME=api.cloudpassage.com
ENV HALO_API_PORT=443

# Package installation
RUN apt-get update && \
    apt-get install -y \
    gcc=4:6.2.1-1ubuntu1 \
    git=1:2.10.2-3 \
    graphviz=2.38.0-16ubuntu1 \
    graphviz-dev=2.38.0-16ubuntu1 \
    linux-headers-generic=4.9.0.15.19 \
    python=2.7.13-2 \
    python-dev=2.7.13-2 \
    python-pip=9.0.1-2


# Install components from pip
RUN pip install \
    boto3==1.4.3 \
    celery[redis]==4.0.2 \
    cloudpassage==${HALO_SDK_VERSION} \
    flower==0.9.1

RUN pip install \
    pygraphviz==1.4rc1 --install-option="--include-path=/usr/include/graphviz" --install-option="--library-path=/usr/lib/graphviz/"

# Setup for manual library installation
RUN mkdir /src/
WORKDIR /src/


# Install Halo Events library
RUN git clone https://github.com/cloudpassage/halo-events
RUN cd halo-events && \
    git checkout ${HALO_EVENTS_VERSION} && \
    pip install .


# Install Halo Scans library
RUN git clone https://github.com/cloudpassage/halo-scans
RUN cd halo-scans && \
    git checkout ${HALO_SCANS_VERSION} && \
    pip install .

# Install Firewall Graph library
RUN git clone https://github.com/cloudpassage-community/firewall-graph
RUN cd firewall-graph && \
    git checkout ${FIREWALL_GRAPH_VERSION} && \
    pip install .

# Install Scan Graph library
RUN git clone https://github.com/cloudpassage-community/scan-graph
RUN cd scan-graph && \
    git checkout ${SCAN_GRAPH_VERSION} && \
    pip install .


# Copy over the app
RUN mkdir /app
WORKDIR /app
RUN git clone https://github.com/ashmastaflash/halocelery
