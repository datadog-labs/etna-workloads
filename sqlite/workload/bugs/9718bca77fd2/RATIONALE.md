# Rationale

All changes are in `ext/misc/regexp.c`, `re_match()`. The fix's hunks applied cleanly in intent (the code had only been restructured slightly with a `goto re_op_cc_inc` label instead of a plain fall-through).

1. `RE_OP_NOTWORD`, `RE_OP_NOTDIGIT`, `RE_OP_NOTSPACE`: removed the `&& c!=0` guard (reverses fix hunks 1-3). `\W`, `\D`, `\S` now match the 0x00 terminator at the end of the input string.
2. `RE_OP_CC_EXC`: removed the `if( c==0 ) break;` guard and merged it back into a shared `case RE_OP_CC_INC: case RE_OP_CC_EXC:` (reverses hunk 4). `[^...]` now matches the terminator.

## Oracle failures (test/regexp2.test)
- 4.1 (`'abc' REGEXP '\W'` gives 1, expected 0)
- 4.8 (`'abc' REGEXP '[^a-z]'` gives 1, expected 0)
- 4.17 and 4.18 (`'abc' REGEXP '\W{1,1}'` and `'\W{1}'` give 1, expected 0)
