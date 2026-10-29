repro.sql enables internal functions (`.testctrl internal_functions 1`) and runs `implies_nonnull_row((b=1 AND a=2)>(b=3 AND a=4),a)` over a LEFT JOIN.

Clean shell prints `1`. Buggy shell aborts with assertion `pWalker->eCode==0` in bothImplyNotNullRow (exit 134).
