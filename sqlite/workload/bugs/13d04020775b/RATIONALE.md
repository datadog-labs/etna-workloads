# Rationale

Hunk: `sqlite3RealSameAsInt()` in `src/vdbemem.c`. The fix added `r1==0.0 ||` so that
a zero real, including -0.0, counts as the same as the integer 0. I removed that
term, which restores the pre-fix body: `memcmp(&r1,&r2,...)==0 && i in range`.
The 3.54.1 code was identical to the fixed version apart from the `LL` suffixes, so
the reversal is direct. The comment line "assumes i was obtained by assignment from r1"
is left in place because it is documentation only.

Effect: `CAST('-0.0' AS numeric)` parses to real -0.0, whose bits differ from (double)0.
`sqlite3VdbeMemNumerify` therefore keeps it as a real and returns -0.0 instead of 0.

Oracle failure: cast-7.40 (`SELECT CAST('-0.0' AS numeric)` expected 0). The other
cases still pass.
