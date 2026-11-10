# test_runner: fix coverage report when a directory is named file

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit a00f5fea7029d3f0791ff6dddabc34b5a0ccf9b4 applied to v26.13.0 (clean).

Upstream commit message:

```
test_runner: fix coverage report when a directory is named file

The coverage tree traversal checked `tree[key].file` to detect file
entries. When a directory named "file" contained a file also named
"file", this check incorrectly matched the child entry instead of
file metadata, causing a TypeError when accessing `.path`.

Check for `.file?.path` instead to correctly identify file metadata.

Fixes: https://github.com/nodejs/node/issues/61080
PR-URL: https://github.com/nodejs/node/pull/61169
Reviewed-By: Aviv Keller <me@aviv.sh>
Reviewed-By: Colin Ihrig <cjihrig@gmail.com>
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
Reviewed-By: Chemi Atlow <chemi@atlow.co.il>
Reviewed-By: Pietro Marchini <pietro.marchini94@gmail.com>
Reviewed-By: Ulises Gascón <ulisesgascongonzalez@gmail.com>
Reviewed-By: Moshe Atlow <moshe@atlow.co.il>
```
