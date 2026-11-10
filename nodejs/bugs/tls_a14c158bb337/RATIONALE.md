# tls: fix case-sensitive SNI context matching

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit a14c158bb337e485d35d23b26cb1c47affa48a46 applied to v26.13.0 (clean).

Upstream commit message:

```
tls: fix case-sensitive SNI context matching

The regex constructed by server.addContext() lacked the case-insensitive
flag, causing uppercase or mixed-case SNI hostnames from ClientHello to
miss their intended context and fall back to the default context. This
violates RFC 6066 Section 3, which states that DNS hostnames are
case-insensitive. In mTLS configurations with per-tenant contexts, this
allowed bypassing client certificate authorization by simply
uppercasing the SNI hostname.

Add the 'i' flag to the RegExp in addContext() so that SNI matching
is case-insensitive.

PR-URL: https://github.com/nodejs-private/node-private/pull/857
Reviewed-By: Antoine du Hamel <duhamelantoine1995@gmail.com>
CVE-ID: CVE-2026-48928
Refs: https://hackerone.com/reports/3656869
```
