# stream: fix uncatchable error closing half-open Duplex.toWeb() writable

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit fe06bf56dc73b3c0f16e711d82cc0ad0712a76c1 applied to v26.13.0 (clean).

Upstream commit message:

```
stream: fix uncatchable error closing half-open Duplex.toWeb() writable

Signed-off-by: Mohamed Sayed <k@3zrv.com>
PR-URL: https://github.com/nodejs/node/pull/64161
Fixes: https://github.com/nodejs/node/issues/64120
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
Reviewed-By: Jason Zhang <xzha4350@gmail.com>
Reviewed-By: Aviv Keller <me@aviv.sh>
```
