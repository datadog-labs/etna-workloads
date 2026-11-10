# module: preserve URL in the parent created by createRequire()

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 4f24aff94ad9160bceaf9dcc9cf5235a65f01029 applied to v26.13.0 (clean).

Upstream commit message:

```
module: preserve URL in the parent created by createRequire()

Previously, createRequire() does not preserve the URL it gets
passed in the mock parent module created, which can be
observable if it's used together with module.registerHooks().
This patch adds preservation of the URL if createRequire()
is invoked with one.

PR-URL: https://github.com/nodejs/node/pull/60974
Fixes: https://github.com/nodejs/node/issues/60973
Reviewed-By: Benjamin Gruenbaum <benjamingr@gmail.com>
Reviewed-By: Geoffrey Booth <webadmin@geoffreybooth.com>
```
