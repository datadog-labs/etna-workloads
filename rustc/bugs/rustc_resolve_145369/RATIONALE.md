# Adapted injection for Do not ICE on private type in field of unresolved struct

Fix: https://github.com/rust-lang/rust/commit/caadc8df3519f1c92ef59ea816eb628345d9f52a

# Rationale
File: compiler/rustc_resolve/src/diagnostics/impls.rs (the function that suggests default fields for struct expressions; moved from diagnostics.rs in 1.99.1).
Re-expresses fix hunk `@@ -2189,9 +2189,9 @@ impl<'ra, 'tcx> Resolver<'ra, 'tcx>`: the fix replaced
`self.partial_res_map[&struct_expr.path.segments.iter().last().unwrap().id].full_res()` with
`segments.last()` + `partial_res_map.get(&segment.id)` early returns. I restored the panicking map index, so an unresolved struct path (no entry in partial_res_map) ICEs.
