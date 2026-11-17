FROM ghcr.io/sagernet/sing-box:latest
COPY config.json /app/config.json
COPY entrypoint.sh /app/entrypoint.sh
ENTRYPOINT ["/bin/sh", "/app/entrypoint.sh"]
