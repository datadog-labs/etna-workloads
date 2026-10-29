# Rationale

Fix: `roundFunc` in src/func.c did not handle the case where `sqlite3AtoF()` fails to parse the printf output "Inf"/"-Inf", so `round(1e500)` returned 0 instead of Inf.

In 3.54.1 the fix's hunk (checking the AtoF return value) cannot be reversed directly: AtoF no longer returns a success flag, and `roundFunc` now has an early guard (`r<-4503599627370496.0 || r>+4503599627370496.0`) that skips infinities before they reach printf.

Change (src/func.c, roundFunc): the guard is replaced with the pre-fix structure. The direct-integer path is used only for `n==0` and a bounded `r`. Everything else, including +/-Inf, goes through `sqlite3_mprintf("%!.*f")` and `sqlite3AtoF()`. AtoF cannot parse "Inf" and stores 0, so the result is 0, which is the pre-fix bug. The unhandled-"Inf" mechanism is the defect the fix addressed.

Oracle: func-4.39 (`SELECT round(1e500), round(-1e500)` expecting `Inf -Inf`) fails. It is the only failure; everything else passes.
