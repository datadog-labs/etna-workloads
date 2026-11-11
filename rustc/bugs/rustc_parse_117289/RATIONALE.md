# Adapted injection for Account for `ref` and `mut` in the wrong place for pattern ident renaming

Fix: https://github.com/rust-lang/rust/commit/b589f474410829046f2f37ff31bd7035b87251fa

compiler/rustc_parse/src/parser/pat.rs, parse_pat_fields: removed the call `self.recover_misplaced_pattern_modifiers(&fields, &mut err);` (and `let mut err` -> `let err`), re-expressing fix hunk `@@ ... parse_pat_fields` (`-let err = ...` / `+let mut err = ...` / `+self.recover_misplaced_pattern_modifiers(&fields, &mut err);`). The helper fn (added by the fix) is kept with #[allow(dead_code)] so it builds; without the call, no `the pattern modifiers belong after the `:`` suggestion is emitted.
