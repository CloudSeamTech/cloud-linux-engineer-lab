#!/usr/bin/env bash
# Generate a private key + CSR, have the internal CA sign it, install the result.
# RE-RUN THIS TO RENEW: it issues a fresh cert with new dates and reloads NGINX.
#   usage: ./issue-cert.sh [common-name] [days]
set -euo pipefail
CN="${1:-internal.lab}"
DAYS="${2:-90}"          # short lifetime on purpose, so you practice renewing
SAN="subjectAltName=DNS:${CN},DNS:localhost,IP:127.0.0.1"

# 1) private key — stays secret, never leaves the server
openssl genrsa -out certs/server.key 2048
# 2) Certificate Signing Request — exactly what you submit to a real CA
openssl req -new -key certs/server.key -out certs/server.csr \
  -subj "/C=US/O=Lab/CN=${CN}" -addext "${SAN}"
# 3) the CA signs the CSR -> your server certificate (SAN is required by browsers now)
openssl x509 -req -in certs/server.csr -CA ca/ca.crt -CAkey ca/ca.key \
  -CAcreateserial -days "${DAYS}" -sha256 -copy_extensions copyall \
  -out certs/server.crt
echo "Issued certs/server.crt for ${CN}, valid ${DAYS} days."
# 4) zero-downtime reload if the container is already running
if podman ps --format '{{.Names}}' | grep -q '^webtls$'; then
  podman exec webtls nginx -s reload && echo "NGINX reloaded with the renewed cert."
fi
