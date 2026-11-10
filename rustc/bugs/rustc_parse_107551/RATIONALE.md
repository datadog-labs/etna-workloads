# Adapted injection for fix parser mistaking const closures for const item

Fix: https://github.com/rust-lang/rust/commit/679dde7338281f958094b409202cc23ce1ba640c

# Rationale
File compiler/rustc_parse/src/parser/mod.rs, fn parse_constness_ (used by parse_constness and parse_closure_constness).
Re-expresses fix hunk `@@ -1203,8 +1204,18 @@ fn parse_constness` which added `(self.check_const_closure() == is_closure) &&` so const closures are not parsed as const items. I removed that condition (and the comment mention), restoring the old behaviour where `const` is eaten as constness for items even before `move`/`|`, so `const move || {}` is misparsed as a const item.
The other fix hunks (parse_closure_constness call in expr.rs; async removal in check_const_closure) are already in a different form / not needed to reproduce the bug.
