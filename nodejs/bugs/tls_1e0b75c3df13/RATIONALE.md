# tls: fix order of setting cipher before setting cert and key

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 1e0b75c3df13bd7ccc1922277846a3b5ec364726 applied to v26.13.0 (clean).

Upstream commit message:

```
tls: fix order of setting cipher before setting cert and key

Set the cipher list and cipher suite before anything else
because @SECLEVEL=<n> changes the security level and
that affects subsequent operations.

Fixes: https://github.com/nodejs/node/issues/36655
Fixes: https://github.com/nodejs/node/issues/49549
Refs: https://github.com/orgs/nodejs/discussions/49634
Refs: https://github.com/orgs/nodejs/discussions/46545
Refs: https://www.openssl.org/docs/man1.1.1/man3/SSL_CTX_set_security_level.html
PR-URL: https://github.com/nodejs/node/pull/50186
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Paolo Insogna <paolo@cowtech.it>
```
