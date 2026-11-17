#!/bin/sh
set -e
PORT="${PORT:-8080}"
sed "s/__PORT__/${PORT}/" /app/config.json > /tmp/config.json
exec sing-box run -c /tmp/config.json
