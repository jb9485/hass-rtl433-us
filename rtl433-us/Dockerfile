ARG BUILD_FROM=ghcr.io/hassio-addons/base:stable
FROM ${BUILD_FROM}

RUN apk add --no-cache rtl-sdr librtlsdr-dev mosquitto-clients jq git cmake build-base libusb-dev

RUN echo -e 'blacklist dvb_usb_rtl28xxu\n\
blacklist dvb_usb_rtl2832u\n\
blacklist dvb_usb_v2\n\
blacklist rtl2832\n\
blacklist rtl2830\n\
blacklist rtl2832_sdr\n\
blacklist rtl2838\n\
blacklist r820t\n\
blacklist dvb_core' > /etc/modprobe.d/blacklist-rtl.conf

COPY run.sh /run.sh
RUN chmod a+x /run.sh

CMD ["/run.sh"]