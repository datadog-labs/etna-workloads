# net: fix address iteration with autoSelectFamily

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 403a72f8ec321066f09d01faa0bffaa4b9783616 applied to v26.13.0 (clean).

Upstream commit message:

```
net: fix address iteration with autoSelectFamily

When `autoSelectFamily` is set to `true`, `net.connect` is supposed to
try connecting to both IPv4 and IPv6, interleaving the address types.
Instead, it appears that the array that holds the addresses in the order
they should be attempted was never used after being populated.

PR-URL: https://github.com/nodejs/node/pull/48258
Reviewed-By: Paolo Insogna <paolo@cowtech.it>
Reviewed-By: Colin Ihrig <cjihrig@gmail.com>
Reviewed-By: Tobias Nießen <tniessen@tnie.de>
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
Reviewed-By: Juan José Arboleda <soyjuanarbol@gmail.com>
```
