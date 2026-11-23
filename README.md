[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/openproject-2?utm_medium=integration&utm_source=button&utm_campaign=openproject)

# OpenProject on Railway

This repo is the source for the **OpenProject** template on Railway. It wraps the official all-in-one image
`openproject/openproject:17.9.8` (pinned by digest) and runs it next to Railway's PostgreSQL.

## What the template deploys

| Service | Source | Notes |
|---|---|---|
| OpenProject | this repo (`Dockerfile`) | Web app, background worker, memcached, Hocuspocus (collaborative editing) and an Apache proxy in one container. Public on port 80. Volume at `/var/openproject/assets` (attachments). Health check: `/health_checks/default` |
| Postgres | Railway PostgreSQL | Database, with its own volume. Private only |

On the first start OpenProject creates its database schema and seed data. That takes about 2 minutes
before the health check passes. Later restarts take under a minute.

## Variables

| Variable | Default | Purpose |
|---|---|---|
| `DATABASE_URL` | `${{Postgres.DATABASE_URL}}` | Private connection to the Postgres service |
| `SECRET_KEY_BASE` | `${{secret(64)}}` | Rails secret for sessions and tokens |
| `OPENPROJECT_SEED__ADMIN__USER__PASSWORD` | generated | First password of the `admin` user. Read it in the service's Variables tab. OpenProject asks you to change it at first login |
| `OPENPROJECT_HOST__NAME` | `${{RAILWAY_PUBLIC_DOMAIN}}` | The public host name. Change it if you add a custom domain |
| `PORT` | `80` | Tells Railway to route traffic to the bundled Apache proxy |

`OPENPROJECT_HTTPS=true` is set in the `Dockerfile`, because Railway serves the app over HTTPS.
Optional settings such as SMTP (`OPENPROJECT_EMAIL__DELIVERY__METHOD`, `OPENPROJECT_SMTP__*`) or the default
language (`OPENPROJECT_DEFAULT__LANGUAGE`) can be added as variables. See the
[OpenProject environment variables](https://www.openproject.org/docs/installation-and-operations/configuration/environment/).

## First login

1. Open the service's Variables tab and copy `OPENPROJECT_SEED__ADMIN__USER__PASSWORD`.
2. Open the public URL and sign in as `admin` with that password.
3. Set your own password when OpenProject asks, then change the admin e-mail under *My account*.

The seed password only applies when the database is created. Changing the variable later does nothing.

## Updates

The `Dockerfile` pins one OpenProject release by version and digest. When a new release is tested here,
the pin is bumped on `main` and the change is listed in [CHANGELOG.md](CHANGELOG.md). Railway then shows
an "update available" notice on projects deployed from the template, and you choose when to apply it.
OpenProject runs its database migrations on start. Back up the Postgres volume before a major upgrade.

## Run it locally

```sh
docker build -t openproject-railway .
docker run -d --name op-db -e POSTGRES_PASSWORD=local -e POSTGRES_DB=railway postgres:17
docker run -d --link op-db -p 8080:80 \
  -e DATABASE_URL=postgresql://postgres:local@op-db:5432/railway \
  -e SECRET_KEY_BASE=$(openssl rand -hex 64) \
  -e OPENPROJECT_SEED__ADMIN__USER__PASSWORD=$(openssl rand -hex 12) \
  -e OPENPROJECT_HOST__NAME=localhost:8080 -e OPENPROJECT_HTTPS=false \
  -v op-assets:/var/openproject/assets openproject-railway
```

OpenProject is © OPEN PROJECT GmbH and licensed under the GPLv3. This repo only holds deployment files.
