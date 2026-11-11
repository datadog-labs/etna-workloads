# Adapted injection for fix(suggestion): insert projection to associated types

Fix: https://github.com/rust-lang/rust/commit/b83dfb5c5a6e9c976200490c89ff00726c425ad2

# Rationale
File: compiler/rustc_hir_analysis/src/check/mod.rs, fn `bounds_from_generic_clauses` (was `bounds_from_generic_predicates`; the fix's hunk `@@ -329,41 +329,52 @@` no longer applies).
The fix added resugaring of projection predicates into the trait bound (`T: Trait<Assoc = K>`), via the `projections_str` loop,
replacing the old FIXME code that pushed `where_clauses.push(format!("{} = {}", def_path_str(projection_def_id), p.term))`.
I reverted that: type-param bounds always go to `where_clauses` as `T: Bound`, the `projections_str`/`bounds_str` logic is removed,
and the old loop `for projection in &projections` pushing `Assoc::Path = term` where clauses is restored. The generics list holds just the param name.
