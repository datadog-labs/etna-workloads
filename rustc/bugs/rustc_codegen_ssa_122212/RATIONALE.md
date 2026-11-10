# Adapted injection for copy byval argument to alloca if alignment is insufficient

Fix: https://github.com/rust-lang/rust/commit/207fe38630fdcfecea048aa41c6a9dd47c19573f

# Hunk: compiler/rustc_codegen_ssa/src/mir/mod.rs, arg_local_refs
Sized-indirect arm no longer copies an underaligned byval argument (pointee_align < layout align) to a fresh alloca; it always uses the incoming pointer directly. This re-expresses the fix hunk `@@ -367,29 +367,45 @@ fn arg_local_refs` (the `if let Some(pointee_align) = attrs.pointee_align && pointee_align < arg.layout.align.abi { alloca + store_fn_arg }` branch), restoring the parent behaviour.
The llvm abi.rs hunk (store using pointee_align) was only needed to support that branch, and is not reinjected.
