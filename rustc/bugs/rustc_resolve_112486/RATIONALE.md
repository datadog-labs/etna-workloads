# Adapted injection for Fix suggestion for E0404 not dealing with multiple generics

Fix: https://github.com/rust-lang/rust/commit/32ae8810fcc6d96a1e7e5447f5b35759ca338ed9

# Rationale
Only file changed: compiler/rustc_resolve/src/late/diagnostics.rs (fn suggesting "constrain the associated type", ~line 1960).
Re-expresses fix hunk `@@ -1087,29 +1087,11 @@` : the fix replaced the hand-built `format!("{}: {}<{} = {}>", snippet(ty), path.segments[..position], path.segments[position..], ident)` with `where_bound_predicate_to_string(&mk_where_bound_predicate(...))`. I restored the old format! string (using qself.position and `constrain_ident`, matching the hunks at `-1050` / `-1079` that dropped `position` and `constrain_ident`), restored the `path_segment_to_string` import (hunk `@@ -10,7 +10,7 @@`), and removed `mk_where_bound_predicate` (hunk `@@ -2605,6 +2587,70 @@`). The pretty-printer helpers (ast_pretty hunks) are left in place; they are harmless unused API.
Result: suggestion appends `<.. = ..>` to a wrong segment list, ignoring existing generics (E0404 multi-generics bug).
