# Adapted injection for Suggest lhs deref for binops

Fix: https://github.com/rust-lang/rust/commit/614ddc969595c412d8db7657e21678283b664d42

# Rationale
File: compiler/rustc_hir_typeck/src/fn_ctxt/suggestions.rs, fn suggest_deref_or_ref (the `&T` vs `T` borrow-suggestion branch).
Removed the block "Suggest dereferencing the lhs for expressions such as `&T <= T`" (if parent is Binary(_, lhs, ..) and lhs type is Ref, return "consider dereferencing the borrow" with `*` on lhs).
Re-expresses fix hunk `@@ -2361,18 +2353,48 @@` which added the `// Suggest dereferencing the lhs for expressions such as `&T == T`` block. The make_sugg closure refactor already exists and is left (harmless). Without it, `if i < 0` gets the "consider borrowing here" suggestion instead of deref.
