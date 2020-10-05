FROM alpine:3.12 as build

RUN apk add \
        automake \
        autoconf \
        cargo \
        cbindgen \
        curl \
        elfutils-dev \
        file-dev \
        gcc \
        git \
        hiredis-dev \
        jansson-dev \
        libpcap-dev \
        libelf \
        libbpf-dev \
        libnetfilter_queue-dev \
        libnetfilter_log-dev \
        libtool \
        linux-headers \
        libcap-ng-dev \
        make \
        musl-dev \
        nss-dev \
        pcre-dev \
        python3 \
        py3-yaml \
        rust \
        yaml-dev \
        zlib-dev

WORKDIR /src

RUN wget https://www.openinfosecfoundation.org/download/suricata-4.1.4.tar.gz &&\
    tar xvf suricata-4.1.4.tar.gz &&\
    cd suricata-4.1.4 &&\
    ./configure \
        --prefix=/usr \
        --sysconfdir=/etc \
        --localstatedir=/var \
        --disable-gccmarch-native \
        --enable-hiredis &&\
    make -j4 &&\
    make install install-conf DESTDIR=/fakeroot


RUN rm -rf /fakeroot/var

FROM alpine:3.12

COPY --from=build /fakeroot /fakeroot