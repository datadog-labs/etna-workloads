# Adapted injection for Pass InferCtxt to InlineAsmCtxt to properly taint on error

Fix: https://github.com/rust-lang/rust/commit/bc4f0bb486bcba6e6e40d0dd7c9df0f9e6aebca9

# Re-injection
File: compiler/rustc_hir_typeck/src/inline_asm.rs (InlineAsmCtxt, all error-emitting sites in check_asm_operand_type, check_asm, etc.)
In 1.99.1 InlineAsmCtxt holds `fcx: &FnCtxt` and errors go through `self.fcx.dcx()`, which is `infcx.dcx()` and taints the InferCtxt on error. I changed every `self.fcx.dcx()` to `self.tcx().dcx()`, which does not taint.
Re-expresses fix hunks such as `-self.tcx.dcx().struct_span_err(expr.span, msg)` / `+self.infcx.dcx().struct_span_err(expr.span, msg)` and `-self.tcx.dcx().span_err(op_sp, msg)` / `+self.infcx.dcx().span_err(op_sp, msg)` (and the @@ -194,7 +200,7 @@ / @@ -398,13 +404,13 @@ ones), in reverse: errors are no longer tainted, so later errors that should be suppressed appear.
