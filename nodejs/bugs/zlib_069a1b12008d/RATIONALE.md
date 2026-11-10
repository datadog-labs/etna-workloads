# zlib: avoid waiting for paused ZIP iterators

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 069a1b12008dd48f7017a44b0d14c03107beb979 applied to v26.13.0 (clean).

Upstream commit message:

```
zlib: avoid waiting for paused ZIP iterators

Track file-backed contentIterator() reads only while I/O is active.
This lets ZipFile.close() finish when an iterator is paused after
yielding a chunk, while still waiting for reads in flight.

Signed-off-by: Kamat, Trivikram <16024985+trivikr@users.noreply.github.com>
Assisted-by: codex:gpt-5.6-sol
PR-URL: https://github.com/nodejs/node/pull/65278
Fixes: https://github.com/nodejs/node/issues/65277
Reviewed-By: James M Snell <jasnell@gmail.com>
```
