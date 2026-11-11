# Adapted injection for Get rid of infer vars in inherent assoc types selection by using probe

Fix: https://github.com/rust-lang/rust/commit/440f46dc165052d56561d7cb4d0808790e141a8e

# Rationale
Only the project.rs hunk of fix.diff still exists in 1.99.1 (the astconv hunks were already restructured; selection now uses `select_inherent_assoc_candidates` with no infer vars).

File: compiler/rustc_trait_selection/src/traits/project.rs, fn `compute_inherent_assoc_term_args`.
Re-expresses fix hunk `@@ -1454,7 +1454,18 @@ pub fn compute_inherent_assoc_ty_args`, which changed `let self_ty = alias_ty.self_ty();` to
`let mut self_ty = ...; if !selcx.infcx.next_trait_solver() { self_ty = normalize_with_depth_to(...) }`.
I removed that normalization, so `self_ty` is used unnormalized again, as before the fix.
Result: ICE "was equal to ... during selection but now it is not" on the late-bound test.
