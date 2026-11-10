# Adapted injection for Make sure that outer opaques capture inner opaques's lifetimes even with precise capturing syntax

Fix: https://github.com/rust-lang/rust/commit/70746d078e0a3dbef1ea96dc94c927c39ab97eab

# Rationale
In 1.99.1 the ast-lowering `lifetime_collector` and `take_extra_lifetime_params` are gone; capture computation lives in
`compiler/rustc_hir_analysis/src/collect/resolve_bound_vars.rs`, `BoundVarContext::visit_opaque_ty`.

Hunk: in the scope walk, `Scope::Opaque { captures, def_id, s }` used to push `(def_id, captures)` onto `opaque_capture_scopes`,
so lifetimes implicitly captured by an inner opaque were also recorded in enclosing opaques (even those with `use<..>`).
I removed the push, so outer opaques no longer capture inner opaques' implicitly captured lifetimes.
This re-expresses the fix's `lifetimes_for_opaque`/`visit_opaque` in lifetime_collector.rs
(`@@ -10,14 +12,41 @@`: "We also recurse on the bounds ... nested opaques, which may *implicitly* capture lifetimes"),
whose absence is the pre-fix bug (outer `use<>` opaque missing inner opaque's lifetimes).
