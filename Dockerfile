FROM alpine:3.4
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
RUN apk add -U \
    font-adobe-100dpi==1.0.3-r0 \
    gcc==5.3.0-r0 \
    git=2.8.3-r0 \
    graphviz==2.38.0-r5 \
    graphviz-dev==2.38.0-r5 \
    linux-headers==4.4.6-r1 \
    musl-dev==1.1.14-r14 \
    python==2.7.12-r0 \
    python-dev==2.7.12-r0 \
    py-pip==8.1.2-r0


# Install components from pip
RUN pip install \
    boto3==1.4.3 \
    celery[redis]==4.0.2 \
    cloudpassage==${HALO_SDK_VERSION} \
    flower==0.9.1




# Setup for manual library installation
RUN mkdir /src/
WORKDIR /src/


# Install Halo Events library
RUN git clone https://github.com/cloudpassage/halo-events
RUN cd halo-events && \
    git checkout ${HALO_EVENTS_VERSION} && \
    pip install .


# Install Halo Events library
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
