# Adapted injection for gvn: bail out unavoidable non-ssa locals in repeat

Fix: https://github.com/rust-lang/rust/commit/be5d6c5425e8dfdf1662225fb23d6deb0e124dd4

# Rationale
Fix: gvn.rs `project(.., from_non_ssa_index)` hunks (`@@ -682,6 +683,7 @@` `*from_non_ssa_index |= self.locals[idx].is_none(); return Some(*inner);`) and the bail-out `else if from_non_ssa_index { return None; }`. Before the fix, indexing a `Value::Repeat` with a non-SSA index was allowed and yielded the repeat's element, even when the result was reached through a place that could not be re-expressed.
In 1.99.1 the code was restructured; the bail-out lives in how non-SSA indices are rejected. Two hunks in compiler/rustc_mir_transform/src/gvn.rs re-allow them:
1. `compute_place_value`: the `proj.try_map(|value| self.locals[value], ..)` now substitutes a dummy value for a non-SSA Index when the base value is `Repeat` (re-expresses the `Index` arm letting non-SSA idx through to `return Some(*inner)`).
2. `new_pointer`: when building `Value::Address`, non-SSA Index operands are accepted if the base local holds a `Repeat`. Later `*elem` is deref'd via `dereference_address` -> `project` Index on Repeat -> inner, so `*elem` becomes `array[idx1]`'s repeated value even though idx1 changed (the removed "bail out unavoidable non-ssa" check). This one is what makes the test fail.
