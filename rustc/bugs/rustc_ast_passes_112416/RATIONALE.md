# Adapted injection for Fix debug ICE for extern type with where clauses

Fix: https://github.com/rust-lang/rust/commit/72421bfb0c2a2a0209fbc96bb9a7d332589661d9

# Rationale
File: compiler/rustc_ast_passes/src/ast_validation.rs, fn `check_foreign_ty_genericless`.
Re-expresses fix hunk `@@ -378,9 +383,14 @@` (replaces `if !generics.where_clause.predicates.is_empty() { cannot_have(where_span, ...) }`
with `check_where_clause` closure checking both before/after clauses via the `where` token flag).
Buggy version: only checks the before-`where` clause (`generics.where_clause.predicates` non-empty), so a `where` clause after `= ty` is not rejected (the case in the issue test). Span is the after clause's span, as in the old `where_clauses.0.1`-style single-span call (hunks 1 and 3, the signature/call-site change, are subsumed since 1.99.1 already passes both clauses).
