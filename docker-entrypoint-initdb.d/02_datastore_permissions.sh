#!/bin/bash

set -e

# Replace placeholders
sed -i \
    -e "s/{datastoredb}/$CKAN_DATASTORE_POSTGRES_DB/g" \
    -e "s/{mainuser}/$CKAN_POSTGRES_USER/g" \
    -e "s/{maindb}/$CKAN_POSTGRES_DB/g" \
    -e "s/{writeuser}/$CKAN_DATASTORE_POSTGRES_WRITE_USER/g" \
    -e "s/{readuser}/$CKAN_DATASTORE_POSTGRES_READ_USER/g" \
    /tmp/set_permissions.sql

# Run commands
psql -U postgres -f /tmp/set_permissions.sql

# Clean up
rm /tmp/set_permissions.sql
