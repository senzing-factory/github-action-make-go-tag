FROM alpine:3.22

RUN apk --no-cache add git git-lfs \
  && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh

HEALTHCHECK CMD git --version || exit 1

USER 1001

ENTRYPOINT ["/entrypoint.sh"]
