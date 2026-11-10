# sqlite: run generator return() on cursor refilter

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 583ee1ce64215ca3c330a4d8267c354bbb39f97a applied to v26.13.0 (clean).

Upstream commit message:

```
sqlite: run generator return() on cursor refilter

SQLite re-invokes xFilter on a cursor it already used, as it does
for the inner table of a correlated subquery or join, abandoning the
previous iterator mid-loop. Call its return() method so generator
`finally` blocks still run.

Refactor the xClose cleanup intoCloseIterator() so both paths share it;
on refilter, a throwing cleanup is surfaced as the query error.

Signed-off-by: Kamat, Trivikram <16024985+trivikr@users.noreply.github.com>
Assisted-by: opencode
PR-URL: https://github.com/nodejs/node/pull/66195
Fixes: https://github.com/nodejs/node/issues/66193
Reviewed-By: Guilherme Araújo <arauujogui@gmail.com>
Reviewed-By: Filip Skokan <panva.ip@gmail.com>
```
