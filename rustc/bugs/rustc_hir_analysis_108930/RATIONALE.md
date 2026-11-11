# Adapted injection for feat: implement better error for manual impl of `Fn*` traits

Fix: https://github.com/rust-lang/rust/commit/a30c2c26c08642dfb6b2c56121bea5ca45465c1b

# Rationale
File: compiler/rustc_hir_analysis/src/hir_ty_lowering/errors.rs, fn `prohibit_assoc_item_constraint`.
The fix's hunk in astconv/errors.rs (`pub fn prohibit_assoc_ty_binding(... segment: Option<(&PathSegment, Span)>)`, which sets
`AssocTypeBindingNotAllowed { span, fn_trait_expansion: if let Some((segment, span)) = segment && segment.args().parenthesized {Some(ParenthesizedFnTraitExpansion{..fn_trait_to_string(..)})} else {None} }`)
is reverted to the pre-fix behaviour where the error carries no parenthesized-Fn expansion help: `fn_trait_expansion: None`.
So E0229 for `impl Fn(u32) -> u32 for S` no longer emits "parenthesized trait syntax expands to ...".
