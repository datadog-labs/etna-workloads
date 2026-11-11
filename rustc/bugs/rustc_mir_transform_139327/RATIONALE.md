# Adapted injection for Allow GVN to produce places and not just locals.

Fix: https://github.com/rust-lang/rust/commit/109edab245e72c876467938d46bd0ad65aaeee0b

All edits in compiler/rustc_mir_transform/src/gvn.rs. In 1.99.1 `try_as_place` already exists (with an extra `allow_complex_projection` arg), so the fix is re-expressed by making GVN produce only locals (not places) at the sites the fix converted.

1. `try_as_operand`: re-expresses hunk `@@ -1672,14 +1660,14 @@ fn op_to_prop_const` (`try_as_local(index) ... Operand::Copy(local.into())` instead of `try_as_place ... Operand::Copy(place)`).
2. `visit_assignment`: re-expresses hunk `@@ -1762,11 +1773,12 @@ impl MutVisitor for VnState` (`try_as_local(value)` and `Rvalue::Use(Operand::Copy(local.into()))` instead of try_as_place, reused_locals.insert(local)).
3. `simplify_place_value`: `try_as_place(value, location, true)` replaced by `try_as_local(...).map(Place::from)`; same "GVN only yields locals, not places" regression (fix's core: "Allow GVN to produce places and not just locals", hunks at 1672/1762 and the new try_as_place at `@@ -1712,6 +1700,29 @@`).
