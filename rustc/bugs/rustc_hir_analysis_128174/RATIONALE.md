# Adapted injection for Don't record trait aliases as marker traits

Fix: https://github.com/rust-lang/rust/commit/12f1463b7e9b1d01b5e46b50d375de0a9026f2b1

# Rationale
compiler/rustc_hir_analysis/src/collect.rs, `trait_def`: changed `let is_marker = !is_alias && find_attr!(attrs, Marker);` back to `let is_marker = find_attr!(attrs, Marker);`.
Re-expresses fix hunk `@@ -1207,25 +1207,29 @@ fn trait_def`: `-let is_marker = tcx.has_attr(def_id, sym::marker);` / `+let is_marker = !is_alias && tcx.has_attr(def_id, sym::marker);` — trait aliases are again recorded as marker traits.
