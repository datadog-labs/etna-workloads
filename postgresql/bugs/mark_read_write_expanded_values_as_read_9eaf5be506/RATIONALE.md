# Rationale

File: src/backend/executor/nodeValuesscan.c, function ValuesNext().
Traces to the fix.patch hunk that adds the MakeExpandedObjectReadOnly() call after ExecEvalExpr() in the per-column loop (and the related attribute lookup and include).
I removed the call, along with the now-unused `attr` variable (the modern form of `att`). The expandeddatum.h include was left alone because other code may still need it, and it is harmless.
Without the call, read/write expanded datums produced by VALUES expressions stay read-write. If they are referenced more than once (in the output projection or in higher plan nodes), one reference can modify or free the object while another still uses it.

Failing oracle case: src/test/regress||plpgsql
