ARG BUILD_FROM=ghcr.io/hassio-addons/base:stable
FROM ${BUILD_FROM}

RUN apk add --no-cache rtl-sdr librtlsdr-dev mosquitto-clients jq

RUN echo 'blacklist dvb_usb_rtl28xxu' > /etc/modprobe.d/blacklist-rtl.conf

COPY run.sh /run.sh
RUN chmod a+x /run.sh

CMD ["/run.sh"]