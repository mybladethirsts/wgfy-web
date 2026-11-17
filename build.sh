#!/bin/sh
set -e
cd "$(dirname "$0")"
if [ -x ./sing-box ]; then
  echo "sing-box already present"
  ./sing-box version || true
  exit 0
fi
API="https://api.github.com/repos/SagerNet/sing-box/releases/latest"
echo "Fetching latest sing-box release info..."
if command -v curl >/dev/null 2>&1; then
  JSON=$(curl -fsSL "$API")
elif command -v wget >/dev/null 2>&1; then
  JSON=$(wget -qO- "$API")
else
  JSON=$(python3 -c "import urllib.request;print(urllib.request.urlopen('$API').read().decode())")
fi
URL=$(printf '%s' "$JSON" | grep -o '"browser_download_url": *"[^"]*linux-amd64[^"]*\.tar\.gz"' | grep -v legacy | head -n 1 | sed 's/.*: *"//; s/"$//')
if [ -z "$URL" ]; then
  echo "Could not determine sing-box download URL" >&2
  exit 1
fi
echo "Downloading $URL"
if command -v curl >/dev/null 2>&1; then
  curl -fSL "$URL" -o sing-box.tar.gz
elif command -v wget >/dev/null 2>&1; then
  wget -q "$URL" -O sing-box.tar.gz
else
  python3 -c "import urllib.request,sys;urllib.request.urlretrieve(sys.argv[1],'sing-box.tar.gz')" "$URL"
fi
tar -xzf sing-box.tar.gz
DIR=$(find . -maxdepth 1 -type d -name 'sing-box-*' | head -n 1)
cp "$DIR/sing-box" ./sing-box
chmod +x ./sing-box
rm -rf sing-box.tar.gz "$DIR"
./sing-box version || true
echo "sing-box ready"
