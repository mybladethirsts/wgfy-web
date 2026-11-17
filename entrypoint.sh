#!/bin/sh
set -e
cd "$(dirname "$0")"
PORT="${PORT:-8080}"
sed "s/__PORT__/${PORT}/" config.json > /tmp/config.json
if [ -x ./sing-box ]; then
  exec ./sing-box run -c /tmp/config.json
else
  exec sing-box run -c /tmp/config.json
fi
