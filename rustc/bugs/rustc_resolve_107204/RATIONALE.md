# Adapted injection for suggest qualifying bare associated constants

Fix: https://github.com/rust-lang/rust/commit/8b12d5f42f98f50e5e47156eea343ea6d32b10db

Hunk: compiler/rustc_resolve/src/late/diagnostics.rs, smart_resolve_context_dependent_help (path.len()==1 branch).
The `items.iter().find(...)` now requires `AssocItemKind::Fn(..)`, so bare associated consts are never found and get no "consider using the associated constant" suggestion.
Re-expresses fix hunk `@@ -227,20 +227,27 @@`: `if let AssocItemKind::Fn(_) = &i.kind && ...` -> `AssocItemKind::Fn(..) | AssocItemKind::Const(..)`.
