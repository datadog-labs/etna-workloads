# http: fix http client leaky with double response

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 59b70e5fe397db2457e10469985cb47fd7af0687 applied to v26.13.0 (fuzzy).

Upstream commit message:

```
http: fix http client leaky with double response

PR-URL: https://github.com/nodejs/node/pull/60062
Fixes: https://github.com/nodejs/node/issues/60025
Reviewed-By: Tim Perry <pimterry@gmail.com>
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
```
