# Adapted injection for fix failure to detect a too-big-type after adding padding

Fix: https://github.com/rust-lang/rust/commit/2ef5897a89f9bbd9d38b9eb1222b5bedef98814b

# Rationale
1. compiler/rustc_abi/src/layout.rs, `univariant_biased`: removed the `size.bytes() >= dl.obj_size_bound()` -> `Err(SizeOverflow)` check after `let size = min_size.align_to(align);`. Re-expresses fix hunk `@@ -1103,6 +1104,10 @@ fn univariant<` (added "if size.bytes() >= dl.obj_size_bound() { return None; }" after `min_size.align_to(align.abi)`). Padding from repr(align) can push size over the bound undetected.
2. compiler/rustc_ty_utils/src/layout/invariant.rs, `layout_sanity_check`: removed the "size is too large" `bug!` check. Re-expresses fix hunk in layout_sanity_check.rs (`if layout.size.bytes() >= ...obj_size_bound() { bug!("size is too large...") }`), file moved in 1.99.1. Without it the too-big type is silently accepted rather than ICEing.
(The fix's first hunk only added a FIXME comment; not reproduced.)
