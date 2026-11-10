# events: remove abort listener from signal in `on`

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 40ef2da8d64cd8172eda750edb893f03dc4c8c7f applied to v26.13.0 (fuzzy).

Upstream commit message:

```
events: remove abort listener from signal in `on`

the `abortHandler` function is declared within the scope of
the `events.on` function so cannot be removed by the caller
which can lead to a memory leak
adding the abort listener using the `addAbortListener` helper
returns a disposable that can be used to clean up the listener
when the iterator is exited

Fixes: https://github.com/nodejs/node/issues/51010
PR-URL: https://github.com/nodejs/node/pull/51091
Reviewed-By: Chemi Atlow <chemi@atlow.co.il>
Reviewed-By: Benjamin Gruenbaum <benjamingr@gmail.com>
```
