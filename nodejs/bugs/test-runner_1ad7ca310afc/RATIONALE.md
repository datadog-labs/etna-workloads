# test_runner: restore directory search for --test

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 1ad7ca310afc7dad38f49b0d3f9d3b59b8f3d6a2 applied to v26.13.0 (fuzzy).

Upstream commit message:

```
test_runner: restore directory search for --test

Passing a directory to `node --test` (e.g. `node --test tests`) matched
the directory itself as a glob pattern and then tried to run it as a
test file, failing with MODULE_NOT_FOUND. Before glob patterns were
supported, a directory argument was searched for test files within it.

Expand a pattern that resolves to a directory into a search for the
default test files inside it. Despite the report framing this as
Windows-only, it reproduces on every platform: it is a plain
regression from when directory arguments stopped being searched.

Fixes: https://github.com/nodejs/node/issues/64555
Signed-off-by: Paul Bouchon <mail@bitpshr.net>
PR-URL: https://github.com/nodejs/node/pull/64637
Reviewed-By: Moshe Atlow <moshe@atlow.co.il>
```
