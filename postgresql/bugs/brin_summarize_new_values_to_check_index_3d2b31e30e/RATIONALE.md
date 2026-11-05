# Rationale

File: src/backend/access/brin/brin.c, function brin_summarize_range() (the current implementation behind brin_summarize_new_values()).

Hunk: fix_impl.patch's addition of the "Must be a BRIN index" check (relkind/relam test, ERRCODE_WRONG_OBJECT_TYPE) and the "User must own the index" ownercheck, both after index_open(). I removed both checks. The function again accepts non-BRIN relations and non-owners. Non-BRIN indexes reach brinsummarize(), and any user can summarize any BRIN index.

The other fix hunks (the lock-ordering and recheck logic) already exist in this function and were left alone. The whitespace-only hunk is not relevant.

Failing oracle case: src/test/regress||brin
