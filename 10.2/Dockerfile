FROM alpine:3.8

ARG VERSION

# Configure environment variables
ENV VERSION="${VERSION}"

RUN set -ex; \
    export CPU=`cat /proc/cpuinfo | grep -c processor`; \
    apk add --update --no-cache \
        bash \
        ca-certificates \
        curl \
        gzip \
        tar \
        unzip \
        openssl \
        wget \
        libstdc++ libaio gnutls ncurses-libs libcurl libxml2 boost \
        alpine-sdk cmake ncurses-dev gnutls-dev curl-dev libxml2-dev libaio-dev linux-headers bison boost-dev; \
    mkdir -p /opt/src; \
    mkdir -p /tmp/_ ; \
    mkdir -p /etc/mysql; \
    addgroup -S -g 500 mysql; \
    adduser -S -D -H -u 500 -G mysql -g "MySQL" mysql; \
    wget -qO- https://downloads.mariadb.org/interstitial/mariadb-${VERSION}/source/mariadb-${VERSION}.tar.gz | tar xz --strip-components=1 -C /opt/src; \
    cd /opt/src; \
    cmake . \
        -DWITHOUT_TOKUDB=1 \
        -DCMAKE_BUILD_TYPE=MinSizeRel \
        -DCOMMON_C_FLAGS="-O3 -s -fno-omit-frame-pointer -pipe" \
        -DCOMMON_CXX_FLAGS="-O3 -s -fno-omit-frame-pointer -pipe" \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DSYSCONFDIR=/etc/mysql \
        -DMYSQL_DATADIR=/var/lib/mysql \
        -DMYSQL_UNIX_ADDR=/run/mysqld/mysqld.sock \
        -DDEFAULT_CHARSET=utf8 \
        -DDEFAULT_COLLATION=utf8_general_ci \
        -DENABLED_LOCAL_INFILE=ON \
        -DINSTALL_INFODIR=share/mysql/docs \
        -DINSTALL_MANDIR=/tmp/_/share/man \
        -DINSTALL_PLUGINDIR=lib/mysql/plugin \
        -DINSTALL_SCRIPTDIR=bin \
        -DINSTALL_DOCREADMEDIR=/tmp/_/share/mysql \
        -DINSTALL_SUPPORTFILESDIR=share/mysql \
        -DINSTALL_MYSQLSHAREDIR=share/mysql \
        -DINSTALL_DOCDIR=/tmp/_/share/mysql/docs \
        -DINSTALL_SHAREDIR=share/mysql \
        -DWITH_READLINE=ON \
        -DWITH_ZLIB=system \
        -DWITH_SSL=bundled \
        -DWITH_LIBWRAP=OFF \
        -DWITH_JEMALLOC=no \
        -DWITH_EXTRA_CHARSETS=complex \
        -DPLUGIN_ARCHIVE=STATIC \
        -DPLUGIN_BLACKHOLE=DYNAMIC \
        -DPLUGIN_INNOBASE=STATIC \
        -DPLUGIN_PARTITION=AUTO \
        -DPLUGIN_CONNECT=NO \
        -DPLUGIN_TOKUDB=NO \
        -DPLUGIN_FEEDBACK=NO \
        -DPLUGIN_OQGRAPH=NO \
        -DPLUGIN_FEDERATED=NO \
        -DPLUGIN_FEDERATEDX=NO \
        -DWITHOUT_FEDERATED_STORAGE_ENGINE=1 \
        -DWITHOUT_EXAMPLE_STORAGE_ENGINE=1 \
        -DWITHOUT_PBXT_STORAGE_ENGINE=1 \
        -DWITHOUT_ROCKSDB_STORAGE_ENGINE=1 \
        -DWITH_EMBEDDED_SERVER=OFF \
        -DWITH_UNIT_TESTS=OFF \
        -DENABLED_PROFILING=OFF \
        -DENABLE_DEBUG_SYNC=OFF \
        -DWITHOUT_MROONGA_STORAGE_ENGINE=YES \
    && make -j${CPU} \
    # Install
    && make -j${CPU} install >/dev/null \
    # Clean everything
    && rm -rf /opt/src \
    && rm -rf /tmp/_ \
    && rm -rf /usr/sql-bench \
    && rm -rf /usr/mysql-test \
    && rm -rf /usr/data \
    && rm -rf /usr/lib/python2.7 \
    && rm -rf /usr/bin/mysql_client_test \
    && rm -rf /usr/bin/mysqltest \
    # Remove packages
    && apk del \
        ca-certificates \
        # Remove no more necessary build dependencies
        alpine-sdk cmake ncurses-dev gnutls-dev curl-dev libxml2-dev linux-headers bison boost-dev libaio-dev \
    # Create needed directories
    && mkdir -p /var/lib/mysql \
    && mkdir -p /run/mysqld \
    && mkdir /etc/mysql/conf.d \
    && mkdir -p /opt/mariadb/pre-init.d \
    && mkdir -p /opt/mariadb/post-init.d \
    && mkdir -p /opt/mariadb/pre-exec.d \
    # Set permissions
    && chown -R mysql:mysql /var/lib/mysql \
    && chown -R mysql:mysql /run/mysqld\
    && chmod -R 755 /opt/mariadb

COPY docker-entrypoint.sh /entrypoint.sh
COPY healthcheck.sh /opt/healthcheck.sh

# Docksal settings
COPY etc /etc
COPY default.cnf /etc/mysql/conf.d/10-default.cnf

EXPOSE 3306

VOLUME ["/var/lib/mysql"]

ENTRYPOINT ["/entrypoint.sh"]

# Health check script
HEALTHCHECK --interval=5s --timeout=1s --retries=12 CMD ["/opt/healthcheck.sh"]
