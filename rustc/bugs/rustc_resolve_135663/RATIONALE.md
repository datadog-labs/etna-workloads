# Adapted injection for Fix ICE in resolving associated items as non-bindings

Fix: https://github.com/rust-lang/rust/commit/067cac91f9f4cde6b0c6cde2681178e9a338a0cd

All hunks in compiler/rustc_resolve/src/late.rs, fn try_resolve_as_non_binding (fix.diff hunks @@ -3960 and @@ -3969, @@ -4005 re-expressed at ~4403-4448):
1. Removed `DefKind::AssocConst` from the `is_syntactic_ambiguity` arm (fix added `| DefKind::AssocConst |` to `Ctor(_, Const) | Const | ConstParam`).
2. Removed `DefKind::AssocConst` from the "unambiguously a fresh binding" arm (fix added it to `Ctor(..) | Const | Static`).
3. `Res::Def(DefKind::Fn | DefKind::AssocFn, _) | Res::Local..` -> `DefKind::Fn` only (fix hunk @@ -4005).
So imported assoc consts/fns reach the unexpected-resolution fallthrough (ICE).
