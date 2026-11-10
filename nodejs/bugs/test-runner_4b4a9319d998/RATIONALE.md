# test_runner: fix escaping in snapshot tests

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 4b4a9319d99897ea4d43823a0ce166dbf165a2b2 applied to v26.13.0 (fuzzy).

Upstream commit message:

```
test_runner: fix escaping in snapshot tests

Snapshotted values are escaped after serialization.
This happens when serializing a value for comparison
when snapshots already exist, and also when updating them.
That is, snapshots are escaped in the internal storage,
but when written to disk, one "level" of escaping is removed.
That escaping is never added back when reading the snapshots back.
This makes even the simplest test trying to serialize a string
with an escape code in it fail, like the one I added here.

PR-URL: https://github.com/nodejs/node/pull/53833
Reviewed-By: Colin Ihrig <cjihrig@gmail.com>
Reviewed-By: Yagiz Nizipli <yagiz@nizipli.com>
Reviewed-By: Moshe Atlow <moshe@atlow.co.il>
Reviewed-By: James M Snell <jasnell@gmail.com>
```
