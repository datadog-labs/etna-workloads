# Adapted injection for Only unpack tupled args in inliner if we expect args to be unpacked

Fix: https://github.com/rust-lang/rust/commit/0391af0e1f617f184d77bbbc093c6595aafab85e

# Hunk: compiler/rustc_mir_transform/src/inline.rs, `try_inlining` (rust-call signature check)
Fix hunk `@@ -222,20 +222,23 @@ impl<'tcx> Inliner<'tcx>` added `&& callee_body.spread_arg.is_none()` to
`if callsite.fn_sig.abi() == Abi::RustCall`, so tuple unpacking only happens when the callee expects unpacked args.
In 1.99.1 that guard is expressed as `if callee_body.spread_arg.is_some() { from_ref(&arg_tuple_ty) } else { unpack tuple }`.
I removed that branch so the tuple is always unpacked (`bug!("Closure arguments are not passed as a tuple")` fires for a generic `I: Tuple`).
