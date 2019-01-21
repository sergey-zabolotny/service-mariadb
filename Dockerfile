ARG VERSION
FROM mariadb:${VERSION}

ARG VERSION
ENV VERSION=${VERSION}

# Docksal settings
COPY mariadb-${VERSION}/default.cnf /etc/mysql/conf.d/10-default.cnf

VOLUME /var/lib/mysql

COPY docker-entrypoint.d /docker-entrypoint.d
COPY healthcheck.sh /opt/healthcheck.sh

EXPOSE 3306
CMD ["mysqld"]

# Health check script
HEALTHCHECK --interval=5s --timeout=1s --retries=12 CMD ["/opt/healthcheck.sh"]
