# Rationale

Changed hunk: src/src/util/vector.h, `vector::expand_vector()` — removed the check
`if (new_capacity <= old_capacity || new_capacity_T <= old_capacity_T) throw default_exception("Overflow encountered when expanding vector");`.

Traces to the `src/util/vector.h` hunk of FIX.diff, which added this overflow check (and the
`new_capacity_T`/`old_capacity_T` computation, which still exists in today's code and is now unused for checking).
Without it, growing a vector past the 32-bit size limit wraps `new_capacity`, so the allocation is too small
and push_back/resize writes out of bounds (the bug the fix removed).

Not reintroduced: the two dl_sparse_table hunks (not needed to fail the oracle test; kept the change minimal).

Final ./check.sh output:
BUILD OK
Segmentation fault  timeout -s KILL 120 setsid ../../build/test-z3 vector
FAIL vector (rc=139)
    timeout: the monitored command dumped core
