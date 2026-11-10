# buffer: stop alloc() uninitialized memory return

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 40a7beeddac9b9ec9ef5b49157daaf8470648b08 applied to v26.13.0 (fuzzy).

Upstream commit message:

```
buffer: stop alloc() uninitialized memory return

CVE-2018-7166
Discovered by ChALkeR - Сковорода Никита Андреевич

Prevent Buffer.alloc(size, fill, number) from returning uninitialized memory.

Fixes: https://github.com/nodejs-private/security/issues/202
PR-URL: https://github.com/nodejs-private/node-private/pull/137
Reviewed-By: Rod Vagg <rod@vagg.org>
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
Reviewed-By: Ruben Bridgewater <ruben@bridgewater.de>
Reviewed-By: Evan Lucas <evanlucas@me.com>
Reviewed-By: Сковорода Никита Андреевич <chalkerx@gmail.com>
Reviewed-By: Michael Dawson <michael_dawson@ca.ibm.com>
```
