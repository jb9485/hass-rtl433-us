ARG BUILD_FROM=ghcr.io/hassio-addons/base:stable
FROM ${BUILD_FROM}

RUN apk add --no-cache rtl-sdr librtlsdr-dev mosquitto-clients jq git cmake build-base libusb-dev

RUN echo -e 'blacklist dvb_usb_rtl28xxu\nblacklist rtl2832\nblacklist rtl2838\nblacklist r820t\nblacklist rtl8xxxu' > /etc/modprobe.d/blacklist-rtl.conf

RUN git clone https://github.com/merbanan/rtl_433.git /tmp/rtl_433 && \
    cd /tmp/rtl_433 && mkdir build && cd build && \
    cmake .. && make -j$(nproc) && make install && \
    rm -rf /tmp/rtl_433

COPY run.sh /run.sh
RUN chmod a+x /run.sh

CMD ["/run.sh"]