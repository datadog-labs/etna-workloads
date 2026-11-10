# Adapted injection for fix the issue of suggest unwrap/expect for shorthand field

Fix: https://github.com/rust-lang/rust/commit/9386e14401b451165630890fa5b8b575dd4723ee

# Rationale
File: compiler/rustc_hir_typeck/src/fn_ctxt/suggestions.rs, fn suggest_unwrapping (the `?`/`.expect` suggestion fn).
Re-expresses fix hunk `@@ -1811,6 +1811,12 @@` which added
`let sugg = match ...maybe_get_struct_pattern_shorthand_field(expr) { Some(ident) => format!(": {ident}{sugg}"), None => ... }`.
In 1.99.1 that match (also with a from_expansion early return) is replaced by `let sugg = sugg.to_string();`, so shorthand fields `Stuff { count }` get `count?` / `.expect` inserted without the `count: ` prefix (invalid suggestion).
