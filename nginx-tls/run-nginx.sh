#!/usr/bin/env bash
# Run NGINX in a ROOTLESS Podman container, serving the internal TLS site on :8443.
# (Rootless can't bind <1024, so we publish to 8443/8080 — see README for the :443 option.)
set -euo pipefail
podman rm -f webtls 2>/dev/null || true
podman run -d --name webtls \
  -p 8080:80 -p 8443:443 \
  -v "$PWD/nginx.conf:/etc/nginx/conf.d/default.conf:ro,Z" \
  -v "$PWD/certs:/etc/nginx/tls:ro,Z" \
  -v "$PWD/html:/usr/share/nginx/html:ro,Z" \
  docker.io/library/nginx:stable
echo "Container 'webtls' is up."
echo "  echo '127.0.0.1 internal.lab' | sudo tee -a /etc/hosts   # one-time name mapping"
echo "  curl -v https://internal.lab:8443                        # trusted once you trust ca/ca.crt"
