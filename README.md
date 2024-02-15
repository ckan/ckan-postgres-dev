# ckan-postgres-dev

Pre-configured Postgres images for rapid CKAN testing, including:

* Users and databases created (main CKAN database and DataStore database). Note: the main CKAN database is not initialized (ie you still need to run `ckan db init`)
* DataStore database permissions set up

**Note**: These images are designed to be used in CI testing, *don't use them in production sites*. You probably don't want to use them for local development either as the database files are located inside the container and not mounted externally, so your database will get wiped once the container is destroyed.

The following versions are available as different image tags:

| CKAN Version | Postgres version | Docker tag |
| --- | --- | --- |
| 2.6 | 9.6 (alpine) | ckan/ckan-postgres-dev:2.6 |
| 2.7 | 9.6 (alpine) |ckan/ckan-postgres-dev:2.7 |
| 2.8 | 11 (alpine) | ckan/ckan-postgres-dev:2.8 |
| 2.9 | 12 (alpine) | ckan/ckan-postgres-dev:2.9 |
| 2.10 | 12 (alpine) | ckan/ckan-postgres-dev:2.9 |
| master (*) | 12 (alpine) | ckan/ckan-postgres-dev:master |

(*) The `master` image is not automatically updated and might be out of date


## Build new images

Use the `make build` command passing the CKAN version and the Postgres image, eg:

    make build CKAN_VERSION=2.9 PG_IMAGE=12-alpine
    make build CKAN_VERSION=master PG_IMAGE=12-alpine
    make build CKAN_VERSION=2.8 PG_IMAGE=11-alpine

The `make check` has the same syntax and can be used to check the generated images:

    make check CKAN_VERSION=2.9 PG_IMAGE=12-alpine
