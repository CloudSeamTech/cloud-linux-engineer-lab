# Internal HTTPS site — NGINX in a container on AlmaLinux

Hosts an internal web page over HTTPS, served by **NGINX in a rootless Podman
container**, using a certificate you **generate a request for, get signed, install,
and renew** — the real enterprise cert lifecycle, in miniature. Pairs with class
modules 3.3 (NGINX/TLS) and 3.4 (containers).

## Prereqs (on your AlmaLinux VM from the `lab-vm` module)
- `sudo dnf install -y podman openssl` (both usually present on AlmaLinux 9; OpenSSL 3.x required)
- `chmod +x *.sh`

## The flow
```
./make-internal-ca.sh          # 1. one-time: stand up your internal CA
sudo cp ca/ca.crt /etc/pki/ca-trust/source/anchors/lab-ca.crt && sudo update-ca-trust
./issue-cert.sh                # 2. generate key + CSR, CA signs it, cert installed
./run-nginx.sh                 # 3. start NGINX in a container serving HTTPS
echo '127.0.0.1 internal.lab' | sudo tee -a /etc/hosts   # 4. name -> the VM
curl -v https://internal.lab:8443                        # 5. verify (trusted, TLS 1.2+)
```

## Renewing (the part you asked about)
A real cert expires — so practice it. `issue-cert.sh` issues a **90-day** cert on
purpose. To **renew**, just run it again:
```
./issue-cert.sh                # new cert, new dates, NGINX auto-reloaded (no downtime)
```
That single command IS the renewal: generate -> sign -> install -> reload.

## What you're actually learning
- **CSR (Certificate Signing Request):** the `server.csr` is what you'd hand a real CA
  (internal PKI, or a public CA). The private key never leaves the box.
- **SAN is mandatory:** modern browsers ignore the old CN field — the cert must list the
  hostnames in `subjectAltName`. The script sets it for you.
- **Internal vs public certs:** internal sites use *your* CA (clients must trust `ca.crt`
  — that's the `update-ca-trust` step, and in an enterprise you'd push it via GPO/Intune).
  A **public** site instead uses a public CA via **ACME / Let's Encrypt** with automatic
  renewal — which matters more every year as public cert lifetimes shrink (heading toward
  ~47 days), making manual renewal a guaranteed outage. Internal CA certs aren't bound by
  those browser limits, but you should still automate.
- **SELinux + containers:** the `:Z` on each `-v` mount relabels the files so SELinux lets
  the container read them. Drop the `:Z` and the container gets "permission denied" even
  though the files look fine — a classic AlmaLinux/RHEL gotcha. (Fix it the right way with
  `:Z`, never by disabling SELinux.)
- **Rootless:** the container runs as your user, not root. That's why it publishes 8443
  instead of 443. To use real 443 rootless, run once:
  `sudo sysctl net.ipv4.ip_unprivileged_port_start=80` and change the `-p` to `443:443`.

## Rep it
`run-nginx.sh` -> verify -> `podman rm -f webtls` -> repeat. Then practice the renewal:
`./issue-cert.sh` and confirm the new expiry with
`openssl x509 -enddate -noout -in certs/server.crt`.
