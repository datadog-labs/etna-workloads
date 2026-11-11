# Adapted injection for Only visit reachable blocks in ConstProp lint.

Fix: https://github.com/rust-lang/rust/commit/7d47a910eba199e321a908cec62ee35bc41535e1

# Rationale
File: compiler/rustc_mir_transform/src/known_panics_lint.rs (the renamed const_prop_lint.rs), `ConstPropagator::visit_body`.
Replaced the worklist loop (`while let Some(bb) = self.worklist.pop() { if !self.visited_blocks.insert(bb) {continue} ... }`)
with `for (bb, data) in body.basic_blocks.iter_enumerated()`, re-expressing the fix hunk
`@@ -566,7 +573,12 @@` (`-for (bb, data) in body.basic_blocks.iter_enumerated() {` / `+while let Some(bb) = self.worklist.pop()`).
Unreachable blocks are linted again. The worklist fields and SwitchInt pruning stay but are now unused (worklist pushes are harmless).
