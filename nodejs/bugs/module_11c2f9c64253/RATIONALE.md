# module: implement Symbol.dispose in ModuleHooks

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 11c2f9c6425348e86c3889d688e3773b0398b80d applied to v26.13.0 (clean).

Upstream commit message:

```
module: implement Symbol.dispose in ModuleHooks

This change implements the `Symbol.dispose` key in the
`ModuleHooks` class as an alias for deregister. This makes
`registerHooks` work with the `using` keyword.

Fixes: https://github.com/nodejs/node/issues/63846
Signed-off-by: Remco Haszing <remcohaszing@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/63928
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
Reviewed-By: René <contact.9a5d6388@renegade334.me.uk>
Reviewed-By: Jacob Smith <jacob@frende.me>
```
