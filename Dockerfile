# syntax=docker/dockerfile:1.7

ARG VARNISH_VERSION=7.5.0

FROM --platform=$BUILDPLATFORM golang:1.27-bookworm AS build

ARG TARGETARCH
ARG TARGETOS
ARG EXPORTER_VERSION=1.6.1

ADD --checksum=sha256:90e5b45a243e9fd159343302d7626bde43abd7585800c479d7a2ff91bf2f848c \
    https://github.com/jonnenauha/prometheus_varnish_exporter/archive/refs/tags/1.6.1.tar.gz \
    /tmp/source.tar.gz

RUN mkdir /src && \
    tar -xzf /tmp/source.tar.gz --strip-components=1 -C /src

WORKDIR /src

RUN CGO_ENABLED=0 GOOS="$TARGETOS" GOARCH="$TARGETARCH" \
    go build -trimpath -ldflags="-s -w -X main.Version=${EXPORTER_VERSION}" \
    -o /out/prometheus_varnish_exporter .

FROM varnish:${VARNISH_VERSION}

ARG BUILD_DATE=unknown
ARG REVISION=unknown
ARG VERSION=unknown

COPY --from=build /out/prometheus_varnish_exporter /usr/local/bin/prometheus_varnish_exporter
COPY --from=build /src/LICENSE /usr/share/licenses/prometheus-varnish-exporter/LICENSE

LABEL org.opencontainers.image.title="MaRDI Prometheus Varnish exporter" \
      org.opencontainers.image.description="Prometheus metrics exporter for Varnish Cache" \
      org.opencontainers.image.source="https://github.com/MaRDI4NFDI/docker-varnish-exporter" \
      org.opencontainers.image.documentation="https://github.com/MaRDI4NFDI/docker-varnish-exporter" \
      org.opencontainers.image.vendor="MaRDI4NFDI" \
      org.opencontainers.image.licenses="MIT AND BSD-2-Clause" \
      org.opencontainers.image.created="$BUILD_DATE" \
      org.opencontainers.image.revision="$REVISION" \
      org.opencontainers.image.version="$VERSION"

USER 999:999
EXPOSE 9131

ENTRYPOINT ["/usr/local/bin/prometheus_varnish_exporter"]
CMD ["-raw", "-web.listen-address=:9131"]
