# repl: fix declaring a variable with the name `util`

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit d6669645c0d77ac5e86a930ac0de25440d060b2e applied to v26.13.0 (fuzzy).

Upstream commit message:

```
repl: fix declaring a variable with the name `util`

The REPL no longer relies on `util` being a reference to the `util` core
module. It still relies on `globalThis` refering to the global object,
but no longer emits warnings when it's overwritten by the user.

PR-URL: https://github.com/nodejs/node/pull/38141
Fixes: https://github.com/nodejs/node/issues/38139
Reviewed-By: Antoine du Hamel <duhamelantoine1995@gmail.com>
Reviewed-By: Benjamin Gruenbaum <benjamingr@gmail.com>
```
