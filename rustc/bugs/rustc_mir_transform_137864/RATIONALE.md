# Adapted injection for Don't drop Rvalue::WrapUnsafeBinder during GVN

Fix: https://github.com/rust-lang/rust/commit/13134dd096db66100db44e08cfa73b7aa9331cf2

compiler/rustc_mir_transform/src/gvn.rs, fn simplify_rvalue: the `Rvalue::WrapUnsafeBinder(ref mut op, _)` arm now does `return self.simplify_operand(op, location);` instead of building `Value::Cast { kind: CastKind::Transmute, value }`.
This re-expresses the fix hunk `@@ -872 ...` which replaced `return self.simplify_operand(op, location);` with a Transmute `Value::Cast`. In 1.99.1 Value::Cast has no from/to fields, so only the arm body is reverted. The wrap is dropped and the binder is treated as its operand during GVN.
