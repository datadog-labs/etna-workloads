# Rationale

Fix hunk (src/tokenize.c, getToken): an unterminated quoted string used to be
returned as TK_STRING; the fix returns TK_ILLEGAL so an "unrecognized token"
error is reported.

Change: in `tree/src/tokenize.c`, `case CC_QUOTE`, the unterminated branch
(`c==0`) now sets `*tokenType = TK_STRING` instead of `TK_ILLEGAL` (still returning `i`,
the pre-fix length for the unterminated case). Today's code splits TK_STRING/TK_ID by
delimiter; only the unterminated case is reverted.

Oracle failure: main-3.2.2 (`select 'abc`) hits an assertion in
sqlite3Dequote (`z[i]`) instead of returning `unrecognized token`; the run aborts, so
main-3.2.3 is not reached either.
