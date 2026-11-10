# crypto: fix raw key export error for wrong key type

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 53cde9d1f87a2f79738b5f581752e1ea3f1ed9be applied to v26.13.0 (clean).

Upstream commit message:

```
crypto: fix raw key export error for wrong key type

Exporting a key in 'raw', 'raw-public' or 'raw-seed' format when the
key type does not match (e.g. an ECDSA private key as 'raw', or an
ML-KEM public key as 'raw-seed') fell through to the generic
NotSupportedError. The Web Crypto and modern-algos export key steps
require an InvalidAccessError in these cases.

Mirror exportKeySpki() and exportKeyPkcs8(): select the exporter per
algorithm first, then check the key type, and drop the type guards
around the call sites in exportKeySync(). Formats an algorithm does
not support (e.g. 'raw' for ML-DSA) still throw NotSupportedError.
This also fixes wrapKey(), which uses the same export path.

Assisted-by: a closed-source coding agent
Signed-off-by: koreahghg <koreahghg@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/66217
Reviewed-By: Filip Skokan <panva.ip@gmail.com>
```
