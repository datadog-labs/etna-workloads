# Rationale

Fix hunk reversed: the one in `jsonParse`'s number parser that added
`if( z[i+1]=='.' ){ ...has5 = 1; jnFlags |= JNODE_JSON5; goto parse_number_2; }`
after the `-`/`+` sign when no digit follows. That is how JSON5 numbers such as
`-.5` and `+.5` (leading decimal point after a sign) get accepted.

In 3.54.1 the same logic is in `jsonTranslateTextToBlob` (src/json.c), in the
`if( !sqlite3Isdigit(z[i+1]) )` block of the sign/number case. I removed the
`if( z[i+1]=='.' ){ hasNonstd=1; t|=0x01; goto parse_number_2; }` block, so a
sign followed by `.` goes to the `iErr = i; return -1` path (malformed JSON),
as before the fix.

Other hunks (`\r` escape, seenDP, `z[j-1]=='-'`) were not touched. They have no
counterpart that can be reverted cleanly in the rewritten parser.

Oracle cases that fail: json501-8.4 (`-.5`), 8.5 (`+.5`), 8.10 (`-.5e-1`),
8.11 (`+.5e-2`). Each gives "malformed JSON" instead of the number.
