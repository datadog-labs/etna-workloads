# Adapted injection for Don't ICE when codegen_select returns ambiguity in new solver

Fix: https://github.com/rust-lang/rust/commit/cc606174a6b18572f523790e80bcd59c95649b2a

# Rationale
File compiler/rustc_ty_utils/src/instance.rs, fn resolve_associated_item.
Fix hunk `@@ -101,18 +101,11 @@ fn resolve_associated_item`: it merged `Err(Ambiguity | Unimplemented | FulfillmentError) => return Ok(None)`, removing the `Err(CodegenObligationError::Ambiguity) => { span_delayed_bug(...); return Err(reported) }` arm.
I restored that separate Ambiguity arm (delayed bug + Err) in 1.99.1's match (which has Ambiguity | Unimplemented merged; FulfillmentError no longer exists, UnconstrainedParam arm kept).
