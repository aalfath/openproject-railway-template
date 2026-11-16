# OpenProject all-in-one image (web, background worker, memcached, Hocuspocus and an Apache proxy
# under supervisord). The database is Railway's Postgres, passed in through DATABASE_URL.
FROM openproject/openproject:17.9.7@sha256:2578c5c0035db87f9b24eb6a845e4f64299721c5459ee2db2abcfe8911208158

# Fixed settings for Railway. Railway terminates TLS in front of the container.
ENV OPENPROJECT_HTTPS=true \
    PG_STARTUP_WAIT_TIME=60

COPY railway-start.sh /usr/local/bin/railway-start.sh
RUN chmod 755 /usr/local/bin/railway-start.sh

EXPOSE 80
ENTRYPOINT ["/usr/local/bin/railway-start.sh"]
CMD ["./docker/prod/supervisord"]
