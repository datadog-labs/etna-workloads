# Adapted injection for on s390x, use `PassMode::Direct` for vector types

Fix: https://github.com/rust-lang/rust/commit/893d81f1e219109d098309d9e3f435b9097da47f

# s390x.rs classify_arg
Reverted fix hunk `@@ -38,9 +38,17 @@` in compiler/rustc_target/src/callconv/s390x.rs (classify_arg): removed the
`if let BackendRepr::SimdVector{..} = arg.layout.backend_repr { return; }` early return (PassMode::Direct),
restoring `if size.bits() <= 128 && arg.layout.is_single_vector_element(cx, size) { arg.cast_to(Reg::opaque_vector(size)); return; }`
so plain vector types go through PassMode::Cast.
