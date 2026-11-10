# Adapted injection for Break critical edges in inline asm before code generation

Fix: https://github.com/rust-lang/rust/commit/5c1733e4f4d51d7887a117a06ac4c465d55c3b8d

# Rationale
File compiler/rustc_mir_transform/src/add_call_guards.rs, fn AddCallGuards::run_pass: removed the
`TerminatorKind::InlineAsm { asm_macro: Asm, .. } if self == &CriticalCallEdges` arm of the first scan
(the one that pushes `Action::Asm { target_index }` for targets with pred_count > 1 when the asm has outputs
and labels/unwind). This re-expresses the fix hunk `@@ -65,6 +65,32 @@ ... impl MirPass for AddCallGuards`, which added
the InlineAsm arm that calls `new_block` on shared targets. Without it, critical edges from asm terminators aren't split.
(Action::Asm handling remains, now dead code -> one dead_code warning.)
