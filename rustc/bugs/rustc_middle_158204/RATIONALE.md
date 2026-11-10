# Adapted injection for More general assert in Interner const fn check

Fix: https://github.com/rust-lang/rust/commit/82bc21a7045eea51903653c3c0946d79b1892a9b

Hunk: compiler/rustc_middle/src/ty/context/impl_interner.rs, `Interner::fn_is_const` debug_assert_matches.
Re-expresses fix hunk `@@ -437,7 +437,7 @@ fn fn_is_const`: `DefKind::Ctor(_, CtorKind::Fn)` -> `DefKind::Ctor(CtorOf::Struct, CtorKind::Fn)` (reverted to the narrower assert), plus the `CtorOf` import (hunk @@ -5,7 +5,7).
Enum variant ctors now trip the debug assertion.
