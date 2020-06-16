FROM million12/nginx-php:php70
MAINTAINER Przemyslaw Ozgo <linux@ozgo.info>

ENV DB_USER=user \
    DB_PASS=password \
    DB_ADDRESS=127.0.0.1 \
    CACTI_VERSION=1.2.11 \
    SPINE_VERSION=1.2.7 \
    TIMEZONE=UTC

RUN \
    rpm --rebuilddb && yum clean all && \
    yum install -y rrdtool net-snmp net-snmp-devel net-snmp-utils mariadb-devel cronie dos2unix autoconf libtool libtool-ltdl-devel help2man && \
    curl -L -o /tmp/cacti-${CACTI_VERSION}.tgz https://github.com/Cacti/cacti/archive/release/${CACTI_VERSION}.tar.gz && \
    mkdir -p /cacti && tar zxvf /tmp/cacti-${CACTI_VERSION}.tgz -C /cacti --strip-components=1 && \
    rm -rf /tmp/cacti-${CACTI_VERSION}.tgz && \
    curl -L -o /tmp/spine-${SPINE_VERSION}.tgz https://github.com/Cacti/spine/archive/release/${SPINE_VERSION}.tar.gz && \
    mkdir -p /tmp/spine && \
    tar zxvf /tmp/spine-${SPINE_VERSION}.tgz -C /tmp/spine --strip-components=1 && \
    rm -f /tmp/spine-${SPINE_VERSION}.tgz && \
    cd /tmp/spine/ && ./bootstrap && ./configure --with-reentrant && make && make install && \
    chown root:root /usr/local/spine/bin/spine && \
    chmod +s /usr/local/spine/bin/spine && \
    rm -rf /tmp/spine && \
    yum remove -y gcc mariadb-devel && \
    yum clean all

COPY container-files /


EXPOSE 80 81 443