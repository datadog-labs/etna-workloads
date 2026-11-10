# Adapted injection for parser: recover from where clauses placed before tuple struct bodies

Fix: https://github.com/rust-lang/rust/commit/70ddde76dfbb03909c565b329f86e49de1f767cc

# Rationale
File compiler/rustc_parse/src/parser/item.rs, fn parse_struct (struct `where` handling).
Re-expresses fix hunk `@@ -1454,8 +1454,16 @@` in item.rs: the fix replaced
`generics.where_clause = self.parse_where_clause()?; if self.eat(&token::Semi)` with
`parse_struct_where_clause(class_name, generics.span)` plus the `if let Some(body) = tuple_struct_body {...}` branch.
Reverted to the old plain `parse_where_clause()`, so struct where-clauses never attempt tuple-struct-body recovery
(the recovery helper in generics.rs becomes unused, as before the fix). Misplaced `where T: Copy, (T);` again yields the generic parse error.
