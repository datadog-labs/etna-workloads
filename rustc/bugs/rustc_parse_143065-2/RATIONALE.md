# Adapted injection for Make recovery for enum with struct field a bit more accurate

Fix: https://github.com/rust-lang/rust/commit/e63921262ccd2ece7e0861d634f111136da1f7da

# Rationale
1. compiler/rustc_parse/src/parser/item.rs, `parse_item_enum` (map_err closure): removed `self.prev_token.is_non_reserved_ident() &&` from the guard, restoring `if self.token == token::Colon {`. Re-expresses fix hunk `@@ -1552,7 +1552,8 @@` (`if self.token == token::Colon` -> `if self.prev_token.is_non_reserved_ident() && self.token == token::Colon`). The bug: recovery suggests "use `struct`" even when the colon follows a keyword such as `where`.
2. compiler/rustc_parse/src/parser/generics.rs, `parse_where_clause_common`: disabled (`if false && ...`) the later-added "unexpected colon after `where`" recovery that eats `:`. In 1.99.1 that recovery consumes the colon before the enum code sees it, so hunk 1 alone is unreachable. Disabling it restores the parent-commit input shape (token `:` after `where`). This is not in fix.diff; it is only needed to make the bug reachable.
