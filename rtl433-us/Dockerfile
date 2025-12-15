ARG BUILD_FROM=ghcr.io/hassio-addons/base:stable
FROM ${BUILD_FROM}

# Install dependencies and build rtl_433
RUN apk add --no-cache \
    rtl-sdr librtlsdr-dev libusb libusb-dev \
    mosquitto-clients jq git cmake build-base openssl-dev

RUN echo 'SUBSYSTEM=="usb", ATTRS{idVendor}=="0bda", ATTRS{idProduct}=="2838", MODE="0666", GROUP="plugdev"' > /etc/udev/rules.d/99-rtl-sdr.rules

RUN git clone https://github.com/merbanan/rtl_433.git /tmp/rtl_433 && \
    mkdir -p /tmp/rtl_433/build && \
    cd /tmp/rtl_433/build && \
    cmake .. -DENABLE_RTLSDR=ON && \
    make -j$(nproc) && \
    make install && \
    rm -rf /tmp/rtl_433

# Copy and make executable in ONE layer
COPY run.sh /run.sh
RUN chmod a+x /run.sh

# Tell the container to run it