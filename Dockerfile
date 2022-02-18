ARG PG_IMAGE=12-alpine
FROM postgres:$PG_IMAGE
MAINTAINER CKAN Tech team

# Postgres settings
ENV POSTGRES_PASSWORD="pass"

# Point Postgres data files to a persistent location inside the container
ENV PGDATA="/data"

# CKAN settings
ENV CKAN_POSTGRES_DB="ckan_test"
ENV CKAN_POSTGRES_USER="ckan_default"
ENV CKAN_POSTGRES_USER_PWD="pass"

ENV CKAN_DATASTORE_POSTGRES_DB="datastore_test"
ENV CKAN_DATASTORE_POSTGRES_READ_USER="datastore_read"
ENV CKAN_DATASTORE_POSTGRES_READ_PWD="pass"
ENV CKAN_DATASTORE_POSTGRES_WRITE_USER="datastore_write"
ENV CKAN_DATASTORE_POSTGRES_WRITE_PWD="pass"

ARG CKAN_VERSION="dev-v2.9"

ADD docker-entrypoint-initdb.d /docker-entrypoint-initdb.d
ADD https://raw.githubusercontent.com/ckan/ckan/$CKAN_VERSION/ckanext/datastore/set_permissions.sql /tmp/set_permissions.sql
RUN chown postgres:postgres /tmp/set_permissions.sql
