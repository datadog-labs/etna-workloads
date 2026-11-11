# Adapted injection for Fix suggestion for matching struct with `..` on both ends

Fix: https://github.com/rust-lang/rust/commit/2a7c6a99ef5c43311a430a07bd4eeab96a7c5d94

All changes in compiler/rustc_parse/src/parser/pat.rs, `parse_pat_fields`; they restore the pre-fix suggestion logic.
- Declarations (`@@ -938,7 +938,8 @@`): replaced `first_etc_and_maybe_comma_span` / `last_non_comma_dotdot_span` with the old single `etc_span`.
- Removed the block computing `first_etc_and_maybe_comma_span` (`@@ -969,12 +970,27 @@`), and re-added `etc_span = Some(etc_sp)` before `break` on `}` and `etc_span = Some(etc_sp.until(self.token.span))` after the comma handling (`@@ -996,7 +1012,6 @@`).
- Removed `last_non_comma_dotdot_span = Some(this.prev_token.span)` (`@@ -1040,6 +1055,9 @@`).
- Final suggestion (`@@ -1049,15 +1067,30 @@`): back to a single "move the `..` to the end of the field list" suggestion that removes etc_span and inserts `{}.. }` at self.token.span, dropping the `.., x, ..` "remove the starting `..`" case.
