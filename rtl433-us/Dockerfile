ARG BUILD_FROM=ghcr.io/hassio-addons/base:stable
FROM ${BUILD_FROM}

RUN apk add --no-cache \
    rtl-sdr librtlsdr-dev libusb-dev mosquitto-clients jq git cmake build-base

RUN git clone --depth 1 https://github.com/merbanan/rtl_433.git /tmp/rtl_433 \
    && mkdir /tmp/rtl_433/build \
    && cd /tmp/rtl_433/build \
    && cmake .. -DENABLE_RTLSDR=ON \
    && make -j$(nproc) \
    && make install \
    && rm -rf /tmp/rtl_433

COPY run.sh /usr/bin/rtl433-run
RUN chmod a+x /usr/bin/rtl433-run

CMD [ "/usr/bin/rtl433-run" ]