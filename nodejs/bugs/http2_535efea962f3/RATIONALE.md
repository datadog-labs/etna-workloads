# http2: do not crash on mismatched ping buffer length

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 535efea962f3187a8e730a7aa9d96e9a6874e4f2 applied to v26.13.0 (clean).

Upstream commit message:

```
http2: do not crash on mismatched ping buffer length

PR-URL: https://github.com/nodejs/node/pull/60135
Reviewed-By: Ruben Bridgewater <ruben@bridgewater.de>
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
Reviewed-By: Tim Perry <pimterry@gmail.com>
Reviewed-By: Rafael Gonzaga <rafael.nunu@hotmail.com>
Reviewed-By: Colin Ihrig <cjihrig@gmail.com>
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
```
