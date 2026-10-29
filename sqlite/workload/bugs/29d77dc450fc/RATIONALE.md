# Rationale

This reverts the fts3/4 "extra defenses against strategically corrupt
databases" fix (2018-11-03) in version-3.54.1, restoring the pre-fix
bounds-checking logic for prefix/suffix-compressed terms in b-tree nodes.

## ext/fts3/fts3.c — fts3ScanInteriorNode()

- Reverted `nAlloc` from `i64` back to `int`.
- Reverted the bounds check from
  `nPrefix>zCsr-zNode || nSuffix>zEnd-zCsr` back to the pre-fix
  `&zCsr[nSuffix]>zEnd` (kept the fix's unrelated `nSuffix==0` check, which
  is a separate, still-valid safeguard not covered by this bug).
- Reverted the allocation size computation from the `(i64)` casts /
  `sqlite3_realloc64` back to plain `int` arithmetic and `sqlite3_realloc`.

These three hunks together are the first hunk of fix.patch for fts3.c.
With `nPrefix`/`nSuffix` read from attacker-controlled varints (up to
0x7FFFFFFF each), `nPrefix+nSuffix` can overflow a 32-bit `int`, and the
pointer-difference check `&zCsr[nSuffix]>zEnd` can itself overflow/wrap,
letting a corrupt node pass validation and causing an undersized
allocation followed by an out-of-bounds `memcpy`.

## ext/fts3/fts3_write.c — fts3SegReaderNext()

- Reverted the end-of-node check from
  `(&pReader->aNode[pReader->nNode] - pNext)<nSuffix` back to the pre-fix
  pointer comparison `&pNext[nSuffix]>&pReader->aNode[pReader->nNode]`.
- Reverted the `nPrefix` sanity check from `nPrefix>pReader->nTerm` back to
  `nPrefix<0` (which is always false since `nPrefix` comes from
  `fts3GetVarint32()` and is unsigned-in-effect) — i.e. no real check.
- Reverted the allocation-size computation from `(i64)` casts and
  `sqlite3_realloc64` back to plain `int` arithmetic and `sqlite3_realloc`.

This reverses the first hunk of fix.patch for fts3_write.c. Note the
fix's third hunk in this function (the doclist-length check, rewritten as
a subtraction to avoid pointer overflow) was left untouched: it is a
distinct check on a different field (`nDoclist`) and reverting it is not
needed to reproduce this bug.

## ext/fts3/fts3_write.c — nodeReaderNext()

- Removed the `if( nPrefix>p->term.n || nSuffix>p->nNode-p->iOff ||
  nSuffix==0 )` bounds check that the fix added (this function had no such
  check before the fix).
- Removed the `if( (p->nNode-p->iOff)<p->nDoclist )` bounds check that the
  fix added on the doclist length.

These are new checks added by the fix's second hunk for fts3_write.c, with
no pre-fix equivalent to restore; removing them reverses the hunk exactly.

## Oracle results

Running `./check.sh`, test/fts3corrupt4.test crashes during case
`fts3corrupt4-1.3`: the corrupted `ft_segdir.root` blob (containing the
`FFFFFFFF0702` overflow trigger that fts3corrupt4-1.2 installs) causes an
out-of-bounds write/overread when `fts3ScanInteriorNode` processes it,
instead of the expected `SQLITE_CORRUPT` "database disk image is
malformed" error. This crash aborts the rest of the test file, so the
remaining 152 of 155 oracle cases are reported as failing (incomplete
run: crash/assert/timeout) — closely matching what the fix's own test
file guards against (each case feeds a strategically corrupted fts3
b-tree node and expects a clean `SQLITE_CORRUPT` error rather than a
crash).
