# Adapted injection for Fix inlining with -Zalways-encode-mir

Fix: https://github.com/rust-lang/rust/commit/fe3cd2d1941a726a0e49b2553de3d4c73a7b4a6d

# Rationale
File: compiler/rustc_mir_transform/src/inline.rs, fn `check_codegen_attributes`.
Re-expresses the fix hunk `@@ -388,14 +388,11 @@ impl<'tcx> Inliner<'tcx>` which removed
`if callsite.callee.def_id().is_local() { ... }` around the "not exported" check, so the check applies to all callees.
Bug re-injected: the `cross_crate_inlinable` / "not exported" check is again guarded by `callee.def_id().is_local()`,
so non-local callees not eligible for inlining (with -Zalways-encode-mir, MIR is available) get inlined, referencing unexported symbols.
