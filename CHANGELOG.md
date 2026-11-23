# Changelog

## 17.9.8 (2026-11-23)

- Breaking changes: none. No new variables. Database migrations, if any, run on start as before.
- Security release: fixes several authorization and data-leak advisories (meeting agenda items, activity details cache, project-membership emails, repository URLs now go through SSRF protection, API v3 work package cache). See the [17.9.8 release notes](https://github.com/opf/openproject/releases/tag/v17.9.8).
- OpenProject 17.9.7 → **17.9.8** (`openproject/openproject:17.9.8@sha256:2d9a77fd8b7781ee3fea84ac232dd449c21ac4f84720b2e3019e8b1a0003684e`).
- Tested on Railway before merging: the published template was deployed, data was written, the service was switched to this version, and the data and login were still there.

## 17.9.7, README update (2026-11-16)

- README only: Deploy on Railway button for the published template `openproject-2`. No change to the app; nothing to apply.

## 17.9.7 (2026-11-16)

- First version of the template: OpenProject 17.9.7 all-in-one image
  (`openproject/openproject:17.9.7@sha256:2578c5c0035db87f9b24eb6a845e4f64299721c5459ee2db2abcfe8911208158`)
  with Railway PostgreSQL, a volume for attachments, a generated admin password and a health check on
  `/health_checks/default`.
