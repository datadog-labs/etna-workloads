# Adapted injection for Don't add associated type bound for non-types

Fix: https://github.com/rust-lang/rust/commit/e4cf708d2fff1ebc8aa7a21a1be152b5247206a1

# Rationale
File: compiler/rustc_hir_analysis/src/hir_ty_lowering/bounds.rs, fn `lower_assoc_item_constraint` (tag selection).

The fix (hunk `@@ -548,6 +548,15 @@ ... ConvertedBindingKind::Constraint(ast_bounds) => { match def_kind { DefKind::AssocTy => {} _ => return Err(emit_err(errors::AssocBoundOnConst ...` ) rejects `Trait<K: Bound>` when K is not an associated type.
In 1.99.1 the equivalent rejection is done by choosing `AssocTag::Type` for Bound constraints, so a const `K` is reported as a kind mismatch. I re-introduce the bug: for a `Bound` constraint whose name resolves to an associated const in the trait, use `AssocTag::Const`, so no error is emitted and lowering proceeds to `projection_term.expect_ty()`, which ICEs.
(The new AssocBoundOnConst diagnostic/ftl hunks have no 1.99.1 counterpart; the other fix hunks are refactors.)
