# Adapted injection for Don't allow transmuting ZSTs in dispatch_from_dyn impl

Fix: https://github.com/rust-lang/rust/commit/3c3186148e4a66a507e606f191c35ed49d873b08

# Rationale
One hunk: compiler/rustc_hir_analysis/src/coherence/builtin.rs, `visit_implementation_of_dispatch_from_dyn` (field filter).
Re-expresses fix hunk `@@ -259,16 +259,25 @@ fn visit_implementation_of_dispatch_from_dyn`: the fix added `&& !ty_a.has_non_region_param()` to the 1-ZST check
(and the parent ran the 1-ZST check before the `ty_a == ty_b` comparison). In 1.99.1 the check had been moved inside the `ty_a == ty_b` branch;
I restored the old behaviour: 1-ZST fields (even ones mentioning type params, e.g. `IsSendToken<T>`) are ignored up-front, with no param check.
The messages.ftl wording change is message text only and was not reverted (no ftl change needed for the behaviour).
