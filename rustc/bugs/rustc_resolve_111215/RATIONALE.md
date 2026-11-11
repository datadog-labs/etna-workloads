# Adapted injection for improve diagnostics and bless tests

Fix: https://github.com/rust-lang/rust/commit/73b3ce26ecf580aec44e45308e952753f5218e07

# Rationale
The fix added a dedicated `ParamInEnumDiscriminant` error (type/const/lifetime), used when `NoConstantGenericsReason::IsEnumDiscriminant`. Before the fix, enum discriminants reported the generic `ParamInNonTrivialAnonConst` error. Re-expressed:

- `compiler/rustc_resolve/src/ident.rs` (`resolve_ident_in_lexical_scope`/ rib walk, type-param and const-param `RibKind::ConstantItem` arms): removed the `IsEnumDiscriminant => ResolutionError::ParamInEnumDiscriminant{..Type/Const}` arms; IsEnumDiscriminant now falls into the `ParamInNonTrivialAnonConst` arm. Re-expresses fix hunks `@@ -1206,13 +1214,22 @@` and `@@ -1262,14 +1282,23 @@` (the `match cause { IsEnumDiscriminant => ... }` additions).
- `compiler/rustc_resolve/src/late/diagnostics.rs` `emit_forbidden_non_static_lifetime_error`: IsEnumDiscriminant now shares the `NonTrivialConstArg` branch (generic anon-const error) instead of `ParamInEnumDiscriminant{Lifetime}`. Re-expresses hunk `@@ -2316,37 +2317,56 @@` (`NoConstantGenericsReason::IsEnumDiscriminant => ... ParamKindInEnumDiscriminant::Lifetime`).
