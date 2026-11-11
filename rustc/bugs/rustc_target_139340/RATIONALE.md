# Adapted injection for Fix RISC-V C function ABI when passing/returning structs containing floats

Fix: https://github.com/rust-lang/rust/commit/5723c9997c41be799fcaec791e591fb8406421ff

# Rationale
Only file changed: compiler/rustc_target/src/callconv/riscv.rs (4 sites: `should_use_fp_conv`-consumer in `classify`/`classify_ret`-style fn at FloatConv::FloatPair/MixedPair arms, and the same two arms in `classify_arg`).
Each `CastTarget::offset_pair(first_ty, second_ty_offset_from_start, second_ty)` was changed back to `CastTarget::pair(first_ty, second_ty)`.
This re-expresses the fix hunks `@@ -171,11 +224,19 @@` and `@@ -239,15 +300,27 @@` (`-arg.cast_to(CastTarget::pair(l, r))` -> `+arg.cast_to(CastTarget::offset_pair(...))`): the parent ignored the second field's offset, so structs like {f32 pad-offset float} get a mis-laid-out cast (e.g. `{ i8, f64 }`/`{f32,f64}`-style padding lost).
The offset tracking plumbing is left in place (unused offsets), only the use is reverted.
