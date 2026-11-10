# Rationale

**Bug:** `tls.checkServerIdentity()` stopped matching IPv6 hosts against `IP Address:` SANs. The IP-SAN branch was gated on `net.isIP()` of the IDNA-normalized hostname. `domainToASCII('::1') === ''`, so `net.isIP('')` is 0 and the branch is skipped. Verification then falls to the DNS path and fails with "Cert does not contain a DNS name". IPv4 is unaffected.

**Hunk (lib/tls.js, `checkServerIdentity`)** corresponds to the fix's only implementation hunk. In today's code the gate is `if (hostnameIsIP)` with `canonicalizeIP(hostname)`. I changed it back to `if (hostnameASCIIIsIP)` with `canonicalizeIP(hostnameASCIIWithoutFQDN)`, which is the pre-fix behaviour. I also removed the explanatory comment the fix added. The new non-canonical-IP check above it is untouched.

**Failing test:** `parallel/test-tls-check-server-identity` fails (stable across 2 runs): `undefined != Cert does not contain a DNS name` (actual: 'Cert does not contain a DNS name'), from the new IPv6 cases.
