# stream: do not pass `readable.compose()` output via `Readable.from()`

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 5e677d6e7e4a04f217ffb79fcbcdadadb02e6fa0 applied to v26.13.0 (fuzzy).

Upstream commit message:

```
stream: do not pass `readable.compose()` output via `Readable.from()`

PR-URL: https://github.com/nodejs/node/pull/60907
Fixes: https://github.com/nodejs/node/issues/55203
Reviewed-By: Raz Luvaton <rluvaton@gmail.com>
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
```
