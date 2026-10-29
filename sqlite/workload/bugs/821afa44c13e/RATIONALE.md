# RATIONALE

Fix reversed: ticket f1580ba1b574e9e9 (RTRIM mishandles control characters at end of string).

In 3.54.1 RTRIM is `rtrimCollFunc` in src/main.c, which trims trailing spaces from both
keys and then calls `sqlite3BinaryCompare`. This is the post-fix design (the fix's
`rtrimCollFunc` hunk), so the `padFlag`/`binCollFunc` hunks cannot be reversed literally.

Change (src/main.c): re-added `allSpaces()` and rewrote `rtrimCollFunc` to the pre-fix
algorithm: memcmp the common prefix, and only if equal treat both remainders as
all-spaces => equal, else `nKey1-nKey2`. This reverses the fix's `rtrimCollFunc` addition and the
`allSpaces`/padFlag logic removal. The semantics are the same as the old
`binCollFunc` with padFlag set; the collation registration is unchanged.

Bug: a trailing space is compared against a control char (< 0x20) in the prefix, so
`' ' > char(20) COLLATE rtrim` returns 1 instead of 0, and index ordering is inconsistent.

Oracle failures (./check.sh): collate1-8.0 and collate1-8.2.
