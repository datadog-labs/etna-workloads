# Rationale

One hunk, src/src/util/sorting_network.h, in psort_nw::mk_at_most_1.
It removes the trailing `if (full) { add_clause(ands); }` before `return result;`.

Traces to the FIX.diff hunk in sorting_network.h that adds, in mk_at_most_1, the
`ands` vector and the final `if (full) add_clause(ands);`. That clause is the
"at most 1 => result" direction of the full encoding. Without it, a full at-most-1
literal is only one-directional: result can be false while at most one input is true.
That is the same at-most-1 compiler bug. The fix's other changes (and_i literals,
n==1 handling) already exist in this release, so only this hunk can be undone.

The sorting_network oracle now fails: test_at_most_1 hits the VERIFY(l_false == res)
at sorting_network.cpp:445 (result1 != result2 is satisfiable).

## ./check.sh output
```
BUILD OK
FAIL sorting_network (rc=114)
    (or and!3 a!1)
```
