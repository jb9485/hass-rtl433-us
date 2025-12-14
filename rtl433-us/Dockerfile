ARG BUILD_FROM=ghcr.io/hassio-addons/base:stable
FROM ${BUILD_FROM}

RUN apk add --no-cache \
    rtl-sdr mosquitto-clients jq git cmake build-base libusb-dev

RUN git clone https://github.com/rtlsdrblog/rtl-sdr-blog.git /tmp/rtl-sdr \
    && cd /tmp/rtl-sdr \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make -j$(nproc) \
    && make install \
    && ldconfig \
    && rm -rf /tmp/rtl-sdr

RUN echo 'blacklist dvb_usb_rtl28xxu' > /etc/modprobe.d/blacklist-rtl.conf

RUN git clone https://github.com/merbanan/rtl_433.git /tmp/rtl_433 && \
    cd /tmp/rtl_433 && mkdir build && cd build && \
    cmake .. && make -j$(nproc) && make install && \
    rm -rf /tmp/rtl_433

COPY run.sh /run.sh
RUN chmod a+x /run.sh

CMD ["/run.sh"]