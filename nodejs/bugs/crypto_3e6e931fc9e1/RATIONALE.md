# crypto: fix public PKCS8 export error

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 3e6e931fc9e18c6dbdac619a91b5b33f6c8ad966 applied to v26.13.0 (clean).

Upstream commit message:

```
crypto: fix public PKCS8 export error

exportKeySpki() already rejects exporting a private key as 'spki'
with an InvalidAccessError, per the Web Crypto export key algorithm
steps for each of RSA, EC, CFRG, ML-DSA, and ML-KEM. exportKeyPkcs8()
was missing the symmetric check: exporting a public key as 'pkcs8'
fell through to the generic "Unable to export ... key using pkcs8
format" NotSupportedError instead of the spec-mandated
InvalidAccessError.

Add the same key-type check to exportKeyPkcs8(), mirroring
exportKeySpki(), and drop the now-redundant type guard around its
call site in exportKeySync(). This also fixes wrapKey(), which
delegates to the same export path.

Add test coverage for both subtle.exportKey('pkcs8', publicKey) and
subtle.wrapKey('pkcs8', publicKey, ...).

Signed-off-by: koreahghg <koreahghg@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/65609
Reviewed-By: Filip Skokan <panva.ip@gmail.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
```
