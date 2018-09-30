FROM golang:1.11-alpine3.8 as builder

ARG QEMU_ARM_STATIC_VERSION="qemu-3.0.0+resin-arm"
ARG S6_OVERLAY_VERSION="v1.21.7.0"
ARG RESIN_XBUILD_COMMIT="d4a214fa36e54febcda6e5126adb2ee2249c64e3"

RUN apk add --no-cache git

RUN mkdir /arm-provider

WORKDIR /arm-provider

RUN wget 'https://github.com/resin-io/qemu/releases/download/v3.0.0%2Bresin/qemu-3.0.0+resin-arm.tar.gz' && \
    tar -xzvf ${QEMU_ARM_STATIC_VERSION}.tar.gz && \
    rm ${QEMU_ARM_STATIC_VERSION}.tar.gz

RUN wget "https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-arm.tar.gz" && \
    mkdir s6_overlay && \
    tar -xzvf s6-overlay-arm.tar.gz -C s6_overlay/ && \
    rm s6-overlay-arm.tar.gz

RUN git clone https://github.com/resin-io-projects/armv7hf-debian-qemu.git && \
    cd armv7hf-debian-qemu && \
    git checkout ${RESIN_XBUILD_COMMIT} && \
    cd .. && \
    go build --ldflags="-s -w" armv7hf-debian-qemu/resin-xbuild.go && \
    rm -rf armv7hf-debian-qemu

RUN mkdir bin && \
    mv resin-xbuild bin/ && \
    mv ${QEMU_ARM_STATIC_VERSION}/qemu-arm-static bin/ && \
    rm -rf ${QEMU_ARM_STATIC_VERSION} && \
    cd bin && \
    ln -s resin-xbuild cross-build-start && \
    ln -s resin-xbuild cross-build-end && \
    ln -s sh sh.real

COPY probe_files /arm-provider/probe_files
RUN chmod 0755 /arm-provider/probe_files/etc/services.d/probe_files/*

FROM alpine:3.8

COPY --from=builder /arm-provider /arm-provider
