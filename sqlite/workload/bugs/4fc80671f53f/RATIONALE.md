# Rationale

## src/func.c, groupConcatInverse()
Reverses the single implementation hunk of the fix. Removed the
`(void)sqlite3_value_text(argv[0]);` call (and its comment) that precedes
`sqlite3_value_bytes(argv[0])`, restoring the original
`int nVS = sqlite3_value_bytes(argv[0]);`. The code is identical to the pre-fix
code. With a UTF16 database and a BLOB argument, the byte count is taken
without first converting to text, so the length removed from the accumulator is
wrong.

## Oracle failures
windowC-2.0 (UTF16 encoding, BLOB input to group_concat window function with
inverse) crashes: `groupConcatStep: Assertion `0' failed`. Cases 1.* pass, as
they do not use UTF16.
