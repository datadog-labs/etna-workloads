# RATIONALE (UNVERIFIED: build failed in this sandbox)

## Bug
checkServerIdentity must treat hosts that normalize (via domainToASCII) to an IPv4 address
(fullwidth digits, ideographic full stop, `127.1`) as IP addresses and match them against IP SANs.
In the buggy state they are treated as DNS names, so an IP host such as `127.1` can match a
`DNS:127.0.0.1` SAN or the CN (hostname check bypass).

## Change (lib/tls.js)
Today's release does not contain the fix's code form: it already has an early-return block
("Host is a non-canonical IP address") for hosts where `net.isIP(hostname)` is false but
`net.isIP(unfqdn(domainToASCII(hostname)))` is true. The fix replaced that handling with
"ip = hostname or normalized host" and matching against IP SANs. I removed the rejection block and
the now-unused `hostnameASCIIIsIP` constant, so such hosts fall through to the DNS-name/CN path
(only `net.isIP(hostname)` selects the IP path), i.e. the pre-fix behaviour where the normalized
host is matched against DNS names/CN.

## Test results
Not verified. `make -j8` fails: `node_mksnapshot` segfaults (exit 139) when generating
node_snapshot.cc. It also segfaults with the original, unmodified lib/tls.js, so it is an
environment/sandbox problem, not caused by this change. The test runs I made used the stale
binary and passed, which says nothing about the change. Expected failing cases in
parallel/test-tls-check-server-identity: the "non-canonical IP address" entries (e.g. host `127.1`
with `DNS:127.0.0.1`), which would return no error instead of
'Host is a non-canonical IP address'.
