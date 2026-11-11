# Adapted injection for ConstBlocks are poly if their substs are poly

Fix: https://github.com/rust-lang/rust/commit/fdaac4e48ea276a595a7cdd08f4801763dfbb6cf

# Rationale
File compiler/rustc_ty_utils/src/consts.rs, `IsThirPolymorphic::expr_is_poly`.
Fix hunk `@@ -302,13 +302,53 @@`: it added `| thir::ExprKind::ConstBlock { substs, .. }` to the `NamedConst` arm (`substs.has_non_region_param()`).
In 1.99.1 the arm was `NamedConst { args, .. } | ConstBlock { args, .. }`. I reverted it to `NamedConst { args, .. }` only. ConstBlock now goes to the non-poly `=> false` list, because the match is exhaustive (the fix also replaced `_ => false` with an explicit list).
