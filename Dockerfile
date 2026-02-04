FROM debian:bookworm-slim

ARG DEPS="isync ca-certificates tzdata"

RUN set -eux; \
  apt-get update && \
  apt-get install -y --no-install-recommends $DEPS &&\
  rm -rf /var/lib/apt/lists/*

# non-rootで動かす（ホスト側volumeの権限に合わせてUID/GIDを変えたいならbuild-arg化してもよい）
RUN useradd -m -u 1000 -s /bin/sh mbsync

USER mbsync
WORKDIR /home/mbsync

# 設定は /config、メールは /mail を前提にする
ENV MBSYNC_CONFIG=/config/mbsyncrc \
  MAILDIR_BASE=/mail \
  TZ=Asia/Tokyo

COPY --chown=mbsync:mbsync entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
