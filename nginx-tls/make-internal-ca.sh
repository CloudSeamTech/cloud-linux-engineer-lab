#!/usr/bin/env bash
# ONE-TIME: create a small INTERNAL Certificate Authority (your private PKI).
# In a real shop this is your enterprise CA; here it's a local stand-in that
# teaches the same CSR -> sign -> issue flow.
set -euo pipefail
mkdir -p ca certs
openssl genrsa -out ca/ca.key 4096
openssl req -x509 -new -nodes -key ca/ca.key -sha256 -days 3650 \
  -subj "/C=US/O=Lab/CN=Lab Internal Root CA" -out ca/ca.crt
echo "Internal CA created: ca/ca.crt"
echo
echo "Trust it on this host so curl/browsers accept certs it signs:"
echo "  sudo cp ca/ca.crt /etc/pki/ca-trust/source/anchors/lab-ca.crt && sudo update-ca-trust"
