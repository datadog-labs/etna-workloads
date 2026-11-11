# Adapted injection for Refactor `powerpc64` call ABI handling

Fix: https://github.com/rust-lang/rust/commit/715728f546ec13fd7e59fd09eef96a15d936fc2a

# Rationale
File: compiler/rustc_target/src/callconv/powerpc64.rs, fn `classify` (the 1.99.1 location of the old abi/call/powerpc64.rs).

The fix merged `classify_ret`/`classify_arg` into one `classify(.., is_ret)`. In the merged function the return
path for non-homogeneous aggregates <= 128 bits uses the argument logic (`@@ -108,7 +67,10 @@`:
`if is_ret && size.bits() > 128 { make_indirect } else if size.bits() <= 64 {...}`), i.e. a
Reg{Integer,size} cast for <=64 bits and i64/i128 arrays otherwise.
I re-expressed the parent's behaviour: the old `classify_ret` (removed in `@@ -41,64 +41,23 @@`) used a separate
size<=128 branch: big-endian `Uniform::new(Reg{Integer,size}, size)`, little-endian rounding to i8/i16/i32/i64.
I added that branch for `is_ret && size.bits() <= 128` (plus the `Endian` import), so returns again use the old, different cast types.
