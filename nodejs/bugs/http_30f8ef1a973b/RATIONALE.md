# http: remove misleading warning

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 30f8ef1a973b97bd5ccd32ae9b3ab6802795004b applied to v26.13.0 (clean).

Upstream commit message:

```
http: remove misleading warning

There are cases where the `'clientError'` event can be emitted multiple
times, even if the socket is correctly destroyed.

Fixes: https://github.com/nodejs/node/issues/51073
PR-URL: https://github.com/nodejs/node/pull/51204
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
Reviewed-By: Paolo Insogna <paolo@cowtech.it>
```
