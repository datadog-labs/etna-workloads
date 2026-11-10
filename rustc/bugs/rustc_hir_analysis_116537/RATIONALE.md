# Adapted injection for Fix suggestion span involving wrongly placed generic arg on enum variants

Fix: https://github.com/rust-lang/rust/commit/23a3b9e44926aa0d4c49a722654ef59f010b55ba

Hunk: compiler/rustc_hir_analysis/src/hir_ty_lowering/errors.rs, fn for GenericsArgsErrExtend::EnumVariant (moved from astconv/mod.rs).
Fix hunk `@@ -1275,8 +1275,10 @@` replaced `assoc_segment.ident.span.shrink_to_hi().to(args.span_ext)` with `args.span_ext.with_lo(args.span_ext.lo() - BytePos(2))`. Re-injected the old form, so the span can stretch across distinct expansions (invalid span -> ICE #116473). The import hunk (BytePos) left alone (BytePos is still used elsewhere or just a warning).
