# Adapted injection for add check for `u8`s and update test

Fix: https://github.com/rust-lang/rust/commit/c6b03ae9b2fd9dab86662741784c8e34e8538c2b

# Rationale
Fix hunks (`compiler/rustc_mir_build/src/thir/constant.rs`, `@@ -44,12 +44,14 @@ lit_to_const`) added `&& let ty::Uint(UintTy::U8) = ty.kind()` to the ByteStr arms so a byte string is only lowered to a valtree when the element type is `u8`.

1. `compiler/rustc_mir_build/src/thir/constant.rs`, `lit_to_const`: both ByteStr arms restored to the old guards (`matches!(inner_ty.kind(), Slice|Array)` and `deref_patterns()` only), and the `UintTy` import dropped. Re-expresses the fix hunks at `@@ -1,5 +1,5 @@` and `@@ -44,12 +44,14 @@`.
2. `compiler/rustc_middle/src/ty/consts/lit.rs`, `const_lit_matches_ty`: in 1.99.1 the same u8 check lives here (the fix's check was moved/duplicated into this predicate, which gates the anon-const literal path). Removed the `U8` element checks in the same two ByteStr arms. Without this, the guard still rejects `b"AAA"` for `&[*mut u8; 3]`, so hunk 1 alone had no observable effect.
