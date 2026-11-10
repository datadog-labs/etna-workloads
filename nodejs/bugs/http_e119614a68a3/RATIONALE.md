# http: wait for pending responses in closeIdleConnections

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit e119614a68a3627f9c05a26938cf58603cfd2f9e applied to v26.13.0 (clean).

Upstream commit message:

```
http: wait for pending responses in closeIdleConnections

PR-URL: https://github.com/nodejs/node/pull/43890
Fixes: https://github.com/nodejs/node/issues/43771
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
Reviewed-By: Rafael Gonzaga <rafael.nunu@hotmail.com>
```
