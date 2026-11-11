# Adapted injection for Account for impossible bounds making seemingly unsatisfyable dyn-to-dyn casts

Fix: https://github.com/rust-lang/rust/commit/c957c4e7043169743355066640d4c18d93264b3e

# Rationale
File: compiler/rustc_borrowck/src/type_check/mod.rs, fn visit_rvalue, `CastKind::PtrToPtr` arm.
Fix hunk `@@ -1457,22 +1458,32 @@` added a first branch `if type_is_sized_modulo_regions(param_env, dst.ty)` (wide-to-thin cast, possibly in an impossible env) so it skips the dyn-to-dyn vtable check. On 1.99.1 that branch also proves `dst.ty: Sized`. I removed the whole branch, so the code goes straight to the dyn-to-dyn check, as before the fix. A fake-sized `dyn Trait<u8>` target is then treated as a wide-to-wide cast.
(The fix's `use InferCtxtExt` hunk is not needed; the import already exists.)
