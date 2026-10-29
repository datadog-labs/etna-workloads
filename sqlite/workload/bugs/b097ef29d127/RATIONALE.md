# Rationale

Fix: substr() read its 2nd/3rd arguments with sqlite3_value_int64 (the fix) instead of sqlite3_value_int, so large values were truncated to 32 bits.

Changes in `tree/src/func.c`, `substrFunc()`:
- `p1 = sqlite3_value_int64(argv[1])` -> `sqlite3_value_int(argv[1])` (reverses hunk 1)
- `p2 = sqlite3_value_int64(argv[2])` -> `sqlite3_value_int(argv[2])` (reverses hunk 2)

p1/p2 are i64 in 3.54.1, but the int result is sign-extended, so values like 0x100000001 are truncated to 1 as before the fix.

Oracle cases failing: func-2.11 (`substr('abcdefg',0x100000001,2)` returns 'ab' instead of ''), func-2.12 (`substr('abcdefg',1,0x100000002)` returns 'ab' instead of 'abcdefg'), and func-2.13.
