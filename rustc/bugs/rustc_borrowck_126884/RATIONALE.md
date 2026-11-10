# Adapted injection for Do not ICE when suggesting dereferencing closure arg

Fix: https://github.com/rust-lang/rust/commit/a2298a6f190a020da69860433b4031775ea82cbe

All in compiler/rustc_borrowck/src/diagnostics/region_errors.rs, `suggest_deref_closure_return`.
1. GenericArgs::for_item closure: removed the `if let ty::GenericParamDefKind::Lifetime = param.kind { re_erased }` branch and restored `if param.index == 0 {` (fix hunk `@@ -1152,7 +1152,9 @@`: `-if param.index == 0 {` / `+ ... && param.name == kw::SelfUpper`). Late-bound lifetimes are no longer erased, so index 0 may be a lifetime and gets the receiver type.
2. Final check: dropped `&& count > 0` (fix hunk `@@ -1169,7 +1171,7 @@`).
