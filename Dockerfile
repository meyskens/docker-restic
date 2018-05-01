ARG ARCH
FROM multiarch/alpine:amd64-edge AS download

RUN apk add --no-cache wget bzip2

ARG VERSION
ARG GOARCH

RUN wget -O restic.bz2 https://github.com/restic/restic/releases/download/v${VERSION}/restic_${VERSION}_linux_${GOARCH}.bz2
RUN bzip2 -d restic.bz2

ARG ARCH
FROM multiarch/alpine:${ARCH}-edge

RUN apk add --no-cache ca-certificates

COPY --from=download /restic /usr/local/bin/restic
RUN chmod +x /usr/local/bin/restic

ENTRYPOINT [ "restic" ]
