# vm: import call should return a promise in the current context

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 1d0b4e8b911a79ed37784191691de0f45543a8df applied to v26.13.0 (clean).

Upstream commit message:

```
vm: import call should return a promise in the current context

A `import` call should returns a promise created in the context where
the `import` was called, not the context of `importModuleDynamically`
callback.

PR-URL: https://github.com/nodejs/node/pull/58309
Fixes: https://github.com/nodejs/node/issues/53575
Reviewed-By: Antoine du Hamel <duhamelantoine1995@gmail.com>
Reviewed-By: Marco Ippolito <marcoippolito54@gmail.com>
```
