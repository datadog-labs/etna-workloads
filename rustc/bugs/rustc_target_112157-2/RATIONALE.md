# Adapted injection for implement vector-containing aggregate alignment for x86 darwin

Fix: https://github.com/rust-lang/rust/commit/a07eb0abbd24e21716d476d7c363270c907f5d2e

# Rationale

File: compiler/rustc_target/src/callconv/x86.rs, nested fn `contains_vector` (inside `compute_abi_info`).

Fix hunk `@@ -53,38 +53,58 @@` in compiler/rustc_target/src/abi/call/x86.rs (the file has since moved to
callconv/x86.rs) added `contains_vector`, which recurses into aggregate fields
(`if contains_vector(cx, layout.field(cx, i)) { return true; }`) and replaced the old
`t.is_like_osx && arg.layout.align.abi >= align_16` ("we should actually be looking inside the type").

The old code never looked inside the type. A literal revert to `align.abi >= align_16` passes the
oracle on 1.99.1, because `Foo` has align 16 anyway. So I re-expressed "does not look inside the type
properly" in the helper: the recursive call is replaced by a check that only matches direct
`SimdVector` fields. A vector nested one aggregate deeper (`DoubleFoo { one: Foo, two: Foo }`) is no
longer detected on Darwin, so it gets byval align 4 instead of 16.

This is an approximation of the old behaviour, not a literal reversal.
