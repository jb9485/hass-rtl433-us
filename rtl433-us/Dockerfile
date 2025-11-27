ARG BUILD_FROM=ghcr.io/hassio-addons/base:stable
FROM ${BUILD_FROM}

# Keep everything else you have (apk add rtl-sdr, git clone rtl_433, etc.)
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

RUN chmod a+x /run.sh
COPY run.sh /run.sh