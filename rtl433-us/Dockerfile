ARG BUILD_FROM=ghcr.io/home-assistant/aarch64-base:latest
FROM $BUILD_FROM

ENV LANG C.UTF-8

RUN apk add --no-cache \
    rtl-sdr \
    libusb \
    libusb-dev \
    mosquitto-clients \
    jq \
    git \
    cmake \
    make \
    gcc \
    g++ \
    build-base \
    linux-headers

# Build latest rtl_433
RUN git clone https://github.com/merbanan/rtl_433.git /tmp/rtl_433 && \
    cd /tmp/rtl_433 && \
    git checkout master && \
    mkdir build && cd build && \
    cmake .. -DENABLE_RTLSDR=ON && \
    make -j$(nproc) && \
    make install && \
    rm -rf /tmp/rtl_433

COPY run.sh /run.sh
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
