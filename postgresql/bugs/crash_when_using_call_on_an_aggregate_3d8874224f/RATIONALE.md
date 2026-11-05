# Rationale

Changed: src/src/backend/parser/parse_func.c, ParseFuncOrColumn().

fix_impl.patch added an early `if (proc_call) ereport(ERROR, "... is not a procedure")` in the
FUNCDETAIL_AGGREGATE branch. In current code the equivalent check is the generic
"reject things that aren't procedures" test near the top, which lists FUNCDETAIL_AGGREGATE.
I removed FUNCDETAIL_AGGREGATE from that list, so CALL on an aggregate is no longer rejected
and proceeds into the aggregate handling code (which expects a normal SELECT context), bringing back the crash.

Failing oracle case: src/test/regress||create_procedure
