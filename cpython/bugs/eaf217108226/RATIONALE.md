# Rationale (gh-126997, Lib/pickletools.py)

Reverted all three implementation hunks of the fix in `tree/Lib/pickletools.py`:

1. `read_stringnl`: removed the `encoding='latin-1'` keyword and went back to `.decode("ascii")`. STRING with non-ASCII bytes raises UnicodeDecodeError again.
2. `read_stringnl_noescape`: no longer passes `encoding='utf-8'`, so GLOBAL/INST/PERSID with non-ASCII names fail to decode (ascii).
3. `dis()`: removed the `ascii(arg)` special case for STRING/BINSTRING/SHORT_BINSTRING; `repr(arg)` is used for all, so non-ASCII bytes are printed raw, not as `\xXX`. (The current code has `arg_text` with colors, so the equivalent branch was removed there.)

Failing oracle cases (2 failures, 2 errors): DisTests.test_string, test_binstring, test_short_binstring (wrong output, not escaped), test_global (UnicodeDecodeError), among others.
