# Rationale
Changed: src/src/pl/plpgsql/src/pl_exec.c, plpgsql_exec_function().
Traces to the pl_exec.c hunk of fix.patch: removed the `else` branch (for a NULL result) that calls exec_cast_value() when `func->fn_retisdomain`. Without it, a NULL returned from a function with a domain return type skips the domain constraint check (e.g. NOT NULL / CHECK), so the bug returns.
The pl_comp.c / plpgsql.h hunks only set/declare fn_retisdomain; they are left in place (field is now unused), which is harmless.

Failing oracle case: src/pl/plpgsql/src||plpgsql_domain
