#!/bin/sh
set -eu

MAILDIR_BASE="/mail"

# 実行間隔（秒）。例: 6時間なら 21600
INTERVAL_SEC="${INTERVAL_SEC:-21600}"

if [ ! -f "${MBSYNC_CONFIG}" ]; then
  echo "mbsync config not found: ${MBSYNC_CONFIG}" >&2
  exit 1
fi

# Maildirベースが無ければ作る
mkdir -p "${MAILDIR_BASE}"

echo "Starting periodic mbsync. interval=${INTERVAL_SEC}s config=${MBSYNC_CONFIG}"

term_handler() {
  echo "Received termination signal. Exiting."
  exit 0
}
trap term_handler INT TERM

while :; do
  echo "=== $(date -Iseconds) mbsync start ==="
  # -V: verbose, -a: all channels
  # 失敗してもコンテナを落とさず次回に回すなら `|| true` を付ける
  mbsync -V -c "${MBSYNC_CONFIG}" -a || echo "mbsync failed (will retry next interval)" >&2
  echo "=== $(date -Iseconds) mbsync end ==="
  sleep "${INTERVAL_SEC}" &
  wait $!
done
