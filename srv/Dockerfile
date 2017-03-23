FROM alpine:edge

RUN apk update \
  && apk add \
    man man-pages \
    bind-tools \
    bash bash-doc bash-completion \
    util-linux coreutils binutils findutils grep \
    build-base gcc abuild binutils binutils-doc gcc-doc gdb \
    git \
    linux-headers \
    make \
    perl \
    cmake cmake-doc \
    iproute2 iproute2-doc iputils \
    tcpdump \
    && rm -rf /var/cache/apk/*

# vim: ai ts=2 sw=2 et sts=2
