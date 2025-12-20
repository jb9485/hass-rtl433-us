ARG BUILD_FROM=ghcr.io/hassio-addons/base:stable
FROM ${BUILD_FROM}

RUN apk add --no-cache mosquitto-clients jq git cmake build-base libusb-dev

RUN echo -e 'blacklist dvb_usb_rtl28xxu\n\
blacklist dvb_usb_rtl2832u\n\
blacklist dvb_usb_v2\n\
blacklist rtl2832\n\
blacklist rtl2830\n\
blacklist rtl2832_sdr\n\
blacklist rtl2838\n\
blacklist r820t\n\
blacklist dvb_core' > /etc/modprobe.d/blacklist-rtl.conf

RUN git clone https://github.com/rtlsdrblog/rtl-sdr-blog.git /tmp/librtlsdr && \
    cd /tmp/librtlsdr && mkdir build && cd build && \
    cmake .. -DDETACH_KERNEL_DRIVER=ON -DINSTALL_UDEV_RULES=OFF && make -j$(nproc) && make install && \
    cd /tmp && rm -rf /tmp/librtlsdr && \
    git clone https://github.com/merbanan/rtl_433.git /tmp/rtl_433 && \
    cd /tmp/rtl_433 && mkdir build && cd build && \
    cmake .. && make -j$(nproc) && make install && \
    cd /tmp && rm -rf /tmp/rtl_433

COPY run.sh /run.sh
RUN chmod a+x /run.sh

CMD ["/run.sh"]