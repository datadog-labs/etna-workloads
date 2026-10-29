# Rationale

Fix: removed the `idx>20` shortcut (no rounding for large precision) in the old
`rounder` logic of `sqlite3_str_vappendf` (%f). The bug it guarded: `%.30f` of a
value far below the requested precision (1.0000000000000000076e-50) produced
wrong output instead of all zeros.

In 3.54.1 the `rounder` code is gone (replaced by `sqlite3FpDecode`), so the
hunk cannot be reversed literally. The same defect class lives on in the
printf digit emission: values entirely below the requested precision.
Change (src/printf.c, "0 digits after the decimal point before the first
significant digit"): removed `if( nn>precision ) nn = precision;`. Leading
zeros are no longer clamped to the precision, so a tiny value emits more zero
digits than `precision` (and overruns `szBufNeeded`).

This is an approximation of the original bug, not an exact reversal; the
original mechanism no longer exists.

Oracle failures: printf-17.11 (`format('%.30f',1.0000000000000000076e-50)` gives
49 zeros after the point instead of 30), printf-2.1.1.1 / 2.1.1.7 (`%.1f` of tiny
values gives `0.00`), and the run aborts at printf-2.1.2.1 with assertion
`length <= szBufNeeded`.
