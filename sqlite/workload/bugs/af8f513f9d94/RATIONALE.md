# Rationale

Fix: the `%c` conversion in sqlite3VXPrintf() copied the character `precision`
times into the fixed-size `buf[etBUFSIZE]` conversion buffer, so precisions
larger than the buffer (70) overflowed it. The fix appended the repeats directly
to the StrAccum instead.

Changed hunk (src/printf.c, `case etCHARX`): replaced the current
`precision>1` block (width/space handling plus `sqlite3StrAppend64`/doubling
copy into the accumulator) with the pre-fix approach: replicate the character
(all its UTF-8 bytes) `precision` times into `buf` and set `length` to the
total. This reverses the fix hunk that introduced `sqlite3AppendChar(pAccum, ..)`
and the `precision>1` block. Width padding then goes through the normal
`adjust_width_for_utf8` path, as in the pre-fix code. (The other fix hunks —
zExtra init, AppendSpace rename — were refactors and are not part of the bug.)

Oracle: printf2-3.1 crashes ("stack smashing detected") because
`%110.100c` writes 100 bytes into the 70-byte buf; the run aborts, so later
cases (3.2..6.x) are reported as failing as part of the incomplete run.
