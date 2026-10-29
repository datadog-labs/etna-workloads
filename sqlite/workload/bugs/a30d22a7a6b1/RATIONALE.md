# Rationale

Fix: guard against integer overflow in printf() width/precision (2015-04-07).
The original hunks (precision<0 clamp, `(i64)N` casts in sqlite3AppendChar and
the StrAccumEnlarge assert) no longer map directly: width/precision are now
i64 and padding uses sqlite3StrAppendchar64.

Changes in tree/src/printf.c:

1. `sqlite3_str_appendchar`: removed the `(i64)N` casts and the testcase, back
   to `p->nChar+N >= p->nAlloc` (reverses the sqlite3AppendChar hunk). Same
   unwidened int addition as before the fix.
2. `case '*'` width: replaced `width = width >= -2147483647 ? -width : 0;` with
   `width = -width;`. This is the modern form of the overflow guard on
   negative `*` widths: without it, INT_MIN becomes +2147483648 (a huge pad
   width) instead of being neutralised.

Oracle failures (test/printf.test): printf-1.17.3 (`%*d` with -2147483648 now
returns NULL/TOOBIG instead of `abd: 1 1`) and printf-3.8 (`%*s` with
-2147483648 likewise fails instead of printing the string).
