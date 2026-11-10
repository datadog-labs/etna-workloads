# src: throw on a malformed localStorage file

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit de34ddcf95ddc5eb4da9924fe9f760b0e4d85edc applied to v26.13.0 (clean).

Upstream commit message:

```
src: throw on a malformed localStorage file

The localStorage backing file is a user-specified path, and the schema
is created with CREATE TABLE IF NOT EXISTS, so a file that already
contains tables of those names is adopted as-is. Its stored values may
then have any SQLite type, but every read asserted the expected type
with CHECK, so a wrong-typed value aborted the process. A bad
schema_version was the worst case: that assertion is in
Storage::Open(), so any access aborted and the application had no
chance to inspect or repair the file.

Report these as ERR_INVALID_STATE instead, matching the throw four
lines below the schema_version assertion for a version that is too new.
Storage::GetAll() has no JavaScript caller to throw at, so it returns
std::nullopt and the DOM storage inspector agent reports a protocol
error.

Now that a failed open returns instead of aborting, Open() has to clean
up after itself: adopt the sqlite3* into a conn_unique_ptr immediately,
so that an error does not leak the connection and leave the next access
to open another one.

Storage::GetAll() also ignored the result of sqlite3_prepare_v2() and
the status its row loop ended on, reporting a malformed file or a
mid-scan error as an empty store. Both now return std::nullopt.

Also drop a redundant second sqlite3_exec() of the init SQL that
clobbered the result of the sqlite3_prepare_v2() above it, hiding
prepare failures behind a misleading "bad parameter or other API
misuse".

Signed-off-by: Trevor Burnham <trevorburnham@gmail.com>
Assisted-by: Claude Opus 5
PR-URL: https://github.com/nodejs/node/pull/65879
Fixes: https://github.com/nodejs/node/issues/65878
Fixes: https://github.com/nodejs/node/issues/64640
Reviewed-By: Colin Ihrig <cjihrig@gmail.com>
Reviewed-By: Trivikram Kamat <trivikr.dev@gmail.com>
```
