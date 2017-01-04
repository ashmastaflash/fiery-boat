FROM alpine:3.4
MAINTAINER @ashmastaflash


# Versions of things and stuff
ENV HALO_SDK_VERSION=1.0.1
ENV HALO_EVENTS_VERSION=v0.10.2
ENV HALO_SCANS_VERSION=v0.11

# Package installation
RUN apk add -U \
    git==2.8.3-r0 \
    python==2.7.12-r0 \
    py-pip==8.1.2-r0


# Install components from pip
RUN pip install \
    celery[redis]==4.0.2 \
    flower==0.9.1 \
    cloudpassage==${HALO_SDK_VERSION}


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


# Copy over the app
COPY app/ /app


WORKDIR /app
