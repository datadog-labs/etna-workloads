# Rationale
Changed hunk: src/src/ast/rewriter/pb2bv_rewriter.cpp, `mk_app(bool full, expr* e, expr_ref& r)`
now passes `false` to the inner mk_app instead of `full`. This traces to the FIX.diff hunk
@@ -726 (mk_app(expr*, expr_ref&) -> mk_app(bool full, ...)), which made the full flag propagate.
Other hunks (signature plumbing, TRACE) already exist in this release; this one line is what
remains, so the `full` flag from pb2bv_rewriter::operator() is dropped and the rewriter always
uses the non-full encoding, giving semantically wrong results (test_semantics fails).

## check.sh result
FAIL pb2bv (rc=114)
