#!/bin/bash
set -euo pipefail
source /etc/suratkita-backup.env
TS=$(date -u +%Y%m%dT%H%M%SZ)
W=$(mktemp -d)
trap 'rm -rf "$W" /tmp/sk-*' EXIT

sqlite3 "$DB_PATH" ".backup '$W/app.db'"
[ "$(sqlite3 "$W/app.db" 'PRAGMA integrity_check;')" = "ok" ]
cp -a "$UPLOAD_DIR" "$W/uploads"
( cd "$W" && find . -type f ! -name MANIFEST.sha256 -exec sha256sum {} \; > MANIFEST.sha256 )

tar -czf "/tmp/sk-$TS.tar.gz" -C "$W" .
age -r "$AGE_RECIPIENT" -o "/tmp/sk-$TS.tar.gz.age" "/tmp/sk-$TS.tar.gz"
SHA=$(sha256sum "/tmp/sk-$TS.tar.gz.age" | cut -d' ' -f1)

put() {
  curl -sf -X PUT -H "x-ms-blob-type: BlockBlob" \
    --data-binary @"$1" "$BASE_URL/$2?$SAS_QS" -o /dev/null
}

put "/tmp/sk-$TS.tar.gz.age" "daily/suratkita-$TS.tar.gz.age"
if [ "$(date +%u)" = "7" ]; then
  put "/tmp/sk-$TS.tar.gz.age" "weekly/suratkita-$TS.tar.gz.age"
fi

echo "$(date -Is) OK suratkita-$TS.tar.gz.age sha256=$SHA size=$(stat -c%s /tmp/sk-$TS.tar.gz.age)" >> /var/log/suratkita-backup.log
