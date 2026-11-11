# Rationale

Changed hunk: `optsmt::box()` in src/src/opt/optsmt.cpp. It traces to the box() hunk of FIX.diff (optsmt.cpp @@ -534).
The fix replaced the single push + geometric_opt()/symba_opt() with a per-objective loop
(each in its own push/pop scope). Today's loop uses geometric_search, because geometric_lex has been renamed.
I restored the old body: one scoped_push, then symba_opt() or geometric_opt(), which optimize all objectives
jointly with a shared bound disjunction. Adding an objective therefore changes the others' optima (#9030).
The geometric_lex is_box hunks have no counterpart in today's code, because the rewritten search no longer
commits earlier objectives and so has no is_box flag.

Final ./check.sh:
BUILD OK
PASS api
FAIL box_independent (rc=114)  (val_max3 == val_max2 failed: 278 vs 429)
PASS box_mod_opt
PASS max_rev
PASS opt_dup_min
PASS scaled_min
