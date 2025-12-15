ARG BUILD_FROM=ghcr.io/hassio-addons/base:stable
FROM ${BUILD_FROM}

RUN apk add --no-cache \
    rtl-sdr librtlsdr-dev libusb-dev \
    mosquitto-clients jq git cmake build-base openssl-dev

RUN mkdir -p /etc/udev/rules.d && \
    echo 'SUBSYSTEM=="usb", ATTRS{idVendor}=="0bda", ATTRS{idProduct}=="2838", MODE="0666"' > /etc/udev/rules.d/99-rtl-sdr.rules

RUN git clone https://github.com/rtlsdrblog/rtl-sdr-blog.git /tmp/rtl-sdr && \
    cd /tmp/rtl-sdr && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j$(nproc) && \
    make install && \
    ldconfig && \
    rm -rf /tmp/rtl-sdr

RUN git clone https://github.com/merbanan/rtl_433.git /tmp/rtl_433 && \
    mkdir -p /tmp/rtl_433/build && \
    cd /tmp/rtl_433/build && \
    cmake .. -DENABLE_RTLSDR=ON && \
    make -j$(nproc) && \
    make install && \
    rm -rf /tmp/rtl_433

COPY run.sh /run.sh
RUN chmod a+x /run.sh

CMD ["/run.sh"]