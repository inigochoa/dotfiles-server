#!/usr/bin/env bash

## pg_dump a PostgreSQL database inside a docker container
## Usage: ./postgres.sh <app>

set -euo pipefail

APP="${1:-}"
if [[ -z "$APP" ]]; then
  echo "Usage: $0 <app>"; exit 1
fi

CONTAINER="${APP}_db"
CID="$(docker ps -aq -f name="^${CONTAINER}$" || true)"

## Exit if container is not found
[[ -z "$CID" ]] && exit 0

DEST="/backups/${APP}.sql.gz"
TMP="${DEST}.tmp"

if ! docker exec -i "$CONTAINER" sh -lc "
  set -euo pipefail
  : \"\${POSTGRES_USER:=postgres}\"
  : \"\${POSTGRES_DB:=\${POSTGRES_USER}}\"
  : \"\${PGPASSWORD:=\${POSTGRES_PASSWORD:-}}\"
  if [ -n \"\${PGPASSWORD}\" ]; then export PGPASSWORD; fi

  pg_dump -h 127.0.0.1 -U \"\${POSTGRES_USER}\" \"\${POSTGRES_DB}\" \
    | gzip -c > \"$TMP\"

  mv -f \"$TMP\" \"$DEST\"
"; then
  echo "[ERR]: failed to create backup for ${CONTAINER}" >&2
  exit 1
fi
