Changed hunk: src/src/muz/transforms/dl_mk_elim_term_ite.cpp (the single hunk of FIX.diff).
The fix replaced `SASSERT(!has_term_ite(fml2))` with a CTRACE, so the "give up" path is taken gracefully.
I restored the SASSERT, so inputs where term-ites remain (z3test smt2/3849.smt2) hit an assertion violation in the debug build instead of printing `unsat`.

check.sh result: z3test:smt2/3849.smt2 FAIL (output "ASSERTION VIOLATION ... Line: 173 !has_term_ite(fml2)" instead of "unsat").
