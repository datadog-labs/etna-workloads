# Adapted injection for Add `AliasKind::Weak` for type aliases.

Fix: https://github.com/rust-lang/rust/commit/f3b7dd6388503ef555f4dbf027d6075ee5c8b3ee

# Re-injection rationale

File/function: compiler/rustc_hir_analysis/src/collect/type_of.rs, `type_alias_is_checked`.

In 1.99.1 the fix's behaviour lives here: a type alias whose HIR contains an opaque type (`HasTait` visitor)
is "checked": `lower_path_segment` (hir_ty_lowering/mod.rs) encodes it as a `Free` (formerly `Weak`) alias and
check.rs wf-checks it. This re-expresses fix hunks in astconv/mod.rs (`@@ -1458,7 +1458,19 @@` `if matches!(def_kind(did), TyAlias) && ty.skip_binder().has_opaque_types() { ... mk_alias(ty::Weak, ..)`)
and wfcheck.rs (`@@ -242,6 +242,12 @@` `hir::ItemKind::TyAlias(hir_ty, ..) => if ...has_opaque_types() { check_item_type(..) }`).

The change: `type_alias_is_checked` now returns only the `checked_type_aliases` feature flag, dropping the opaque-type
detection. Aliases containing opaque types are again eagerly substituted and not wf-checked (pre-fix behaviour).
