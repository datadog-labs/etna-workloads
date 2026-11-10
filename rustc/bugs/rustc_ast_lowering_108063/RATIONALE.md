# Adapted injection for Move associated type bounds check to ast lowering

Fix: https://github.com/rust-lang/rust/commit/e7c490892f440afb1e34b3c2315aca04f51cd070

# Rationale
One hunk: compiler/rustc_ast_lowering/src/lib.rs, `lower_assoc_item_constraint` (`AssocItemConstraintKind::Bound` arm).
Re-expresses fix hunk `@@ -1040,7 +1038,13 @@` in ast_lowering/src/lib.rs, which replaced
`ImplTraitContext::Disallowed(_) if self.is_in_dyn_type => (true, itctx_tait)` with an emitted `MisplacedAssocTyBinding` error
(moving the ATB-in-dyn check to lowering). Reverting it means ATB inside dyn types is no longer rejected at lowering
(`if self.is_in_dyn_type` -> `if false && self.is_in_dyn_type`), so these positions (ADT fields, impl headers, where-clause dyn) are no longer diagnosed with the "only allowed in where clauses and function signatures" error.
The ast_passes hunks (struct/enum-only ban) were not restored, since 1.99.1 has no equivalent machinery.
