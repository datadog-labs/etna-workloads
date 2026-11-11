# Adapted injection for run borrowck tests on BIDs and emit tail-expr-drop-order lints for potential violations

Fix: https://github.com/rust-lang/rust/commit/045271ccccd6c485f65ed94aeef3357a512e22fb

# Rationale
One hunk: compiler/rustc_borrowck/src/lib.rs, `visit_statement_before_primary_effect` (MirBorrowckCtxt ResultsVisitor).
Fix hunk re-expressed: `@@ -636,9 +638,11 @@` which moved `StatementKind::BackwardIncompatibleDropHint` out of the
"does not affect borrowck" no-op arm into an arm calling `self.check_backward_incompatible_drop(location, ...)`.
Bug re-injected: BIDs are again a no-op in borrowck, so no TAIL_EXPR_DROP_ORDER lint is emitted for potential borrowck violations.
The rest of the fix (helper fn, lint, ftl, scope.rs) already exists in 1.99.1 and is left untouched (now dead code -> warnings only).
