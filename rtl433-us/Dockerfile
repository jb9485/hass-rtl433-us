ARG BUILD_FROM=ghcr.io/home-assistant/aarch64-base:latest
FROM $BUILD_FROM

ENV LANG=C.UTF-8

RUN apk add --no-cache \
    rtl-sdr \
    librtlsdr-dev \
    libusb \
    libusb-dev \
    mosquitto-clients \
    jq \
    git \
    cmake \
    build-base \
    openssl-dev

# Build latest rtl_433
RUN git clone https://github.com/merbanan/rtl_433.git /tmp/rtl_433
WORKDIR /tmp/rtl_433
RUN mkdir build
WORKDIR /tmp/rtl_433/build
RUN cmake .. -DENABLE_RTLSDR=ON
RUN make -j$(nproc)
RUN make install
WORKDIR /
RUN rm -rf /tmp/rtl_433

COPY run.sh /run.sh
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
