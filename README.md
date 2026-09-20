# docker-varnish-exporter

Multi-architecture container image for
[`prometheus_varnish_exporter`](https://github.com/jonnenauha/prometheus_varnish_exporter),
published as `ghcr.io/mardi4nfdi/varnish-exporter`.

The exporter is used in Wikimedia production and is packaged by Debian. No
maintained upstream container image is available, so this repository combines
the exporter with the official Varnish image. Keeping `varnishstat` in the
image makes it possible to read a Varnish instance's shared VSM directory.

## Usage

Mount the same `/var/lib/varnish` volume as the Varnish container:

```console
docker run --rm -p 9131:9131 \
  -v varnish-workdir:/var/lib/varnish:ro \
  ghcr.io/mardi4nfdi/varnish-exporter:latest
```

Metrics are available at `http://localhost:9131/metrics`.

The image currently contains:

- `prometheus_varnish_exporter` 1.6.1
- `varnishstat` from Varnish 7.5.0

Release tags follow semantic versioning. Builds from `main` also publish
`latest` and `sha-<commit>` tags. Images are built for `linux/amd64` and
`linux/arm64`.

## Provenance

The upstream source archive is pinned by SHA-256 in the Dockerfile. GitHub
Actions publishes an SBOM and build provenance alongside each image.

The GitHub Actions build and release configuration was adapted from
[`swh:1:rev:5171de3ab35a24fdbb1f67bd296915a9e2e5dc34`](https://archive.softwareheritage.org/swh:1:rev:5171de3ab35a24fdbb1f67bd296915a9e2e5dc34;origin=https://github.com/MaRDI4NFDI/docker-wikibase).

The repository's `LICENSE` is the unmodified OSI-approved MIT licence from
`prometheus_varnish_exporter`. The image also contains Varnish Cache from the
official image under its OSI-approved BSD-2-Clause licence.
