# Rationale

Changed hunk: src/src/cmd_context/pdecl.cpp, pdecl_manager::instantiate_datatype.
Traces to the FIX.diff hunk in pdecl.cpp that added `notify_datatype(r, p, n, s)` on the
cached path (`if (r) { notify_datatype(...); return r; }`). The fix makes sure that
a datatype sort found in the cache is still announced (notify_new_dt) if it hadn't been yet.
I reverted that to `if (r) return r;`, so sorts found in the cache are never notified, and
datatype instantiations (accessors/constants such as DDy) are missing -> bug #3930.
The other FIX.diff hunks are whitespace-only or are the m_notified/notify_datatype refactor (kept as-is).

## check.sh output
BUILD OK
FAIL z3test:smt2/3930.smt2 (rc=1)
    1c1,2
    < unsat
    ---
    > (error "line 16 column 19: unknown constant DDy ((DD Int)) Int ")
    > sat
