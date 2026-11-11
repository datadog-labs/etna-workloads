# Adapted injection for Fix invalid suggestion from type error for derive macro

Fix: https://github.com/rust-lang/rust/commit/11959a8b6e75d2c55500a703070a248342d29549

# Rationale
File: compiler/rustc_hir_typeck/src/fn_ctxt/suggestions.rs, fn suggest_into (the `Into::into` suggestion check).
Removed the guard
`&& !expr.span.macro_backtrace().any(|x| matches!(x.kind, ExpnKind::Macro(MacroKind::Attr | MacroKind::Derive, ..)))`
and the now-unused `ExpnKind`, `MacroKind` imports. This re-expresses fix hunks
`@@ -1365,6 +1365,10 @@` (added the `&& !expr.span.macro_backtrace()...` condition) and
`@@ -23,7 +23,7 @@` (import of ExpnKind, MacroKind). The formatting-only hunk is not relevant.
Effect: the `.into()` suggestion is again emitted for errors inside derive/attr macro expansions.
