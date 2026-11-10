# crypto: don't disable TLS 1.3 without suites

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 9cde7a033e66a8e9e691c708cfb448161fa2c27d applied to v26.13.0 (clean).

Upstream commit message:

```
crypto: don't disable TLS 1.3 without suites

In the manual page, there is a statement that ciphersuites contain
explicit default settings - all TLS 1.3 ciphersuites enabled.
In node, we assume that an empty setting mean no ciphersuites and
we disable TLS 1.3. A correct approach to disabling TLS 1.3 is to
disable TLS 1.3 and by not override the default ciphersuits
with an empty string.

So, only override OpenSSL's TLS 1.3 ciphersuites with an explicit
list of ciphers. If none are acceptable, the correct approach is
to disable TLS 1.3 instead elsewhere.

Fixes: https://github.com/nodejs/node/issues/43419

PR-URL: https://github.com/nodejs/node/pull/43427
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
Reviewed-By: Paolo Insogna <paolo@cowtech.it>
Reviewed-By: James M Snell <jasnell@gmail.com>
```
