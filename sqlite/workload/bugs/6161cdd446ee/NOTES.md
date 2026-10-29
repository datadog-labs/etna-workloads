repro.sql runs the three printf-19.x format() cases (zero-precision %f/%g rounding).
The injection removes the `precision==0 -> 1` fix for %g and changes the rounding branch in the digit decoder, so the buggy shell prints wrong rounded results for these; the clean shell prints `1 0.09 2`, `0 0.`, `123,450,000,000,000 1,234,500,000,000,000`.
