#!/bin/bash
# Small wrapper around OpenProject's own entrypoint for Railway.
set -e

# Railway sets PORT=80 so its proxy and health check reach Apache, which listens on port 80.
# OpenProject's Puma server also reads PORT, and Apache proxies to Puma on 8080, so Puma
# must keep 8080 inside the container.
export PORT=8080

# The all-in-one image only starts its bundled Postgres when DATABASE_URL points at 127.0.0.1.
# On Railway, DATABASE_URL is the Postgres service's private URL.
if [ -z "${DATABASE_URL:-}" ]; then
  echo "DATABASE_URL is not set. Link the Postgres service (DATABASE_URL=\${{Postgres.DATABASE_URL}})." >&2
  exit 1
fi

if [ -z "${SECRET_KEY_BASE:-}" ] || [ "$SECRET_KEY_BASE" = "OVERWRITE_ME" ]; then
  echo "SECRET_KEY_BASE is not set. Set it to a long random value (the template uses \${{secret(64)}})." >&2
  exit 1
fi

cd /app
exec ./docker/prod/entrypoint.sh "$@"
