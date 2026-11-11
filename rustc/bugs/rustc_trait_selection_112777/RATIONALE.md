# Adapted injection for Continue folding in query normalizer on weak aliases

Fix: https://github.com/rust-lang/rust/commit/493b18b65380b36baa4b9997417e1c33cbc4fdb2

# Rationale
File: compiler/rustc_trait_selection/src/traits/query/normalize.rs, fn `QueryNormalizer::try_fold_free_or_assoc`.

Re-expresses the fix hunk `@@ -322,8 +322,12 @@` which added
`|| kind == ty::Weak` to the "keep folding" condition (comment: "`tcx.normalize_weak_ty` will only unwrap one layer ... continue folding it to reveal the TAIT behind it").
In 1.99.1 weak aliases are `FreeTy`/`FreeConst`; the matches!(term.kind, FreeTy|FreeConst) clause is removed, so after normalizing a free alias one layer, the result is no longer re-folded unless it has HAS_CONST_ALIAS. The TAIT behind a weak alias is not revealed, and debuginfo hits it.
