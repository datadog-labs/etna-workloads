# Adapted injection for Address feedback

Fix: https://github.com/rust-lang/rust/commit/a8e3abd04cf85080d921c2d1875e0094b2db5155

# Rationale
File compiler/rustc_passes/src/check_attr.rs, fn `check_proc_macro`.
1.99.1 already compares the signature by unification: it instantiates fn_sig with fresh inference args (`fresh_args_for_item`) and `ocx.eq`s it with the expected sig. This re-expresses the fix hunk `@@ -2103,23 +2109,30 @@` (old `tcx.fn_sig(id)` and strict `!= tokenstream` comparison replacing `drcx.types_may_unify(...)` with `TreatParams::AsInfer`). The fix made generic params act as inference vars. I restored the old behaviour by using `fn_sig(def_id).instantiate_identity()` and dropping `fresh_args`. Generic params like `T` are then rigid and no longer match `TokenStream`, so `pub fn foo<T>(t: T) -> TokenStream` is rejected (issue #102923).
