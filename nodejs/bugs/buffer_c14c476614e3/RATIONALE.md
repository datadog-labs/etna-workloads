# buffer: fix 6-byte writeUIntBE() range check

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit c14c476614e3134867ddb997bdfe5a41ba668175 applied to v26.13.0 (clean).

Upstream commit message:

```
buffer: fix 6-byte writeUIntBE() range check

Fixes: https://github.com/nodejs/node/issues/30420

PR-URL: https://github.com/nodejs/node/pull/30459
Reviewed-By: Anna Henningsen <anna@addaleax.net>
Reviewed-By: David Carlier <devnexen@gmail.com>
Reviewed-By: Colin Ihrig <cjihrig@gmail.com>
Reviewed-By: Ruben Bridgewater <ruben@bridgewater.de>
Reviewed-By: James M Snell <jasnell@gmail.com>
```
