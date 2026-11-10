# zlib: avoid caching invalid ZIP local headers

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 745ad771566d6f0133eee775a661f48056f2cf50 applied to v26.13.0 (clean).

Upstream commit message:

```
zlib: avoid caching invalid ZIP local headers

The lazy file-backed ZIP resolver cached a parsed local header before
checking it against the central directory. A failed check therefore left
the entry with a cached header and unresolved content offset, allowing a
later read to use the file descriptor's current position.

Validate the local header and calculate its content offset before
committing either value to the entry.

Assisted-by: Pi
Signed-off-by: Matteo Collina <hello@matteocollina.com>
PR-URL: https://github.com/nodejs-private/node-private/pull/981
Refs: https://hackerone.com/reports/4004290
Reviewed-By: Robert Nagy <ronagy@icloud.com>
CVE-ID: CVE-2026-106070
```
