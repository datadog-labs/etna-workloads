# Rationale

Reverts ec7eef6b1103 ("Avoid caching expression state trees for domain constraints across queries"). Only `src/backend/utils/cache/typcache.c` changed.

The fix kept only plan trees in the typcache and rebuilt expression state trees per ref. Today's code has an extra `need_exprstate` flag and a separate `check_exprstate` field, so the revert is adapted to that.

1. `load_domaintype_info()`, which traces to the hunk that replaced `ExecInitExpr(check_expr, NULL)` with the cast of the plan tree. `check_exprstate` is now built once with `ExecInitExpr` and stored in the long-lived `DomainConstraintState`. This happens after switching out of the dcc context, so the state tree lives in the caller's (per-query) memory context. The state is then cached for the life of the backend, as in the pre-fix code.
2. `prep_domain_constraints()`, which traces to the hunk that added it and its call sites in `InitDomainConstraintRef` and `UpdateDomainConstraintRef`. It now copies the cached `check_exprstate` pointer instead of calling `ExecInitExpr` per ref. Every query therefore reuses a state tree that was built in an earlier query's context, which is the bug.

I did not reverse the `refctx` hunk. `refctx` is still needed in the current code.

The first attempt built the state inside the dcc context. That version still passed, because modern SQL-function code no longer leaves per-query pointers in the state. I then moved the `ExecInitExpr` call after the context switch back, which gives the dangling per-query-context state.

Failing oracle case: `src/test/regress||domain`. The result is `missing`, probably a backend crash.
