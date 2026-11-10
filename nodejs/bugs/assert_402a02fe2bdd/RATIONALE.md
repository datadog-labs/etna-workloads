# assert: cap input size in myersDiff to avoid Int32Array overflow

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 402a02fe2bdd8b591e0b2ebc5b27d76e82b53b07 applied to v26.13.0 (clean).

Upstream commit message:

```
assert: cap input size in myersDiff to avoid Int32Array overflow

PR-URL: https://github.com/nodejs/node/pull/59578
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Ruben Bridgewater <ruben@bridgewater.de>
```
