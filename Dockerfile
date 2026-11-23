# OpenProject all-in-one image (web, background worker, memcached, Hocuspocus and an Apache proxy
# under supervisord). The database is Railway's Postgres, passed in through DATABASE_URL.
FROM openproject/openproject:17.9.8@sha256:2d9a77fd8b7781ee3fea84ac232dd449c21ac4f84720b2e3019e8b1a0003684e

# Fixed settings for Railway. Railway terminates TLS in front of the container.
ENV OPENPROJECT_HTTPS=true \
    PG_STARTUP_WAIT_TIME=60

COPY railway-start.sh /usr/local/bin/railway-start.sh
RUN chmod 755 /usr/local/bin/railway-start.sh

EXPOSE 80
ENTRYPOINT ["/usr/local/bin/railway-start.sh"]
CMD ["./docker/prod/supervisord"]
