# http2: fix FileHandle leak in respondWithFile

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit f0be1c00da356954ba7f47e5c39fe7dc0e85fe89 applied to v26.13.0 (fuzzy).

Upstream commit message:

```
http2: fix FileHandle leak in respondWithFile

Ensure that the file handle is closed if header validation fails in
respondWithFile. This prevents ERR_INVALID_STATE errors where a
FileHandle object is closed during garbage collection.

PR-URL: https://github.com/nodejs/node/pull/61707
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
Reviewed-By: Tim Perry <pimterry@gmail.com>
```
