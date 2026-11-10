# RATIONALE

## Bug
`tls.checkServerIdentity()` did not normalize the hostname with IDNA (`domainToASCII`) before matching.
Hostnames containing Unicode dot separators (e.g. `foo。bar.example.com`) were therefore split on
ASCII `.` only, so `foo。bar.example.com` was treated as a single label and matched `*.example.com`,
whereas after normalization it is `foo.bar.example.com` (CVE-2026-48618).

## Changes (lib/tls.js)
1. Removed `const { domainToASCII } = require('internal/url')` and the `hostnameASCII` /
   `hostnameASCIIWithoutFQDN` computation — corresponds to the fix's import hunk and the hunk adding
   `domainToASCII(hostname)`; restored the old `hostname = unfqdn(hostname)`.
2. `splitHost(hostnameASCIIWithoutFQDN)` -> `splitHost(hostname)` — matching on the un-normalized host, as before the fix.
3. IP check uses `hostname` (as before; the fix switched it to the ASCII form). In today's code this
   already used `hostname`, so I also removed the later "non-canonical IP address" guard, which depends
   on the ASCII form and did not exist before the fix.

## Failing tests
`parallel/test-tls-check-server-identity` fails: Test# 55 (`0127.0.0.1` expected
`Host is a non-canonical IP address`, got `Host: 0127.0.0.1. is not in the cert's altnames: DNS:87.0.0.1`).
The test file in the release also includes the fix's `foo。bar.example.com` case, which the reverted code
would likewise fail (it runs after/before depending on order; the assertion script stops at the first failure).
