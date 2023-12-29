FROM alpine:3.19

RUN apk --no-cache add git git-lfs \
 && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
