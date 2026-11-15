#!/bin/sh
# ===========================================================================
# Grocy entrypoint for a non-root container (TOS 7 requirement).
#
# The LinuxServer image serves the app with nginx on port 80, which uid 1000
# cannot bind. This wrapper runs the same PHP application with the built-in PHP
# web server on port 8080 and keeps the data folder on the mounted volume.
# ===========================================================================
set -e
set -u

DATA=/config/data
mkdir -p "$DATA" 2>/dev/null || true

if ! ( : > "$DATA/.write-test" ) 2>/dev/null; then
  echo "grocy: $DATA is not writable by uid $(id -u)" >&2
  exit 1
fi
rm -f "$DATA/.write-test"

export GROCY_DATA_DIR="$DATA"

cd /app/grocy/public
exec php -S 0.0.0.0:8080 -t /app/grocy/public
