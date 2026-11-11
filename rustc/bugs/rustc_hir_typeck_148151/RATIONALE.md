# Adapted injection for Replace OffsetOf by an actual sum.

Fix: https://github.com/rust-lang/rust/commit/72444372ae6900792ae53bec89c2ab442d589a71

# Rationale
1.99.1 already contains the fix (offset_of intrinsic + sum in THIR), so a literal reverse (restoring NullOp::OffsetOf) isn't feasible. I re-expressed the fix's typeck hunks instead.

File/function: compiler/rustc_hir_typeck/src/expr.rs, `check_expr_offset_of`.
Fix hunks re-expressed (hunk `@@ -3975,7 +3973,7 @@`, `-field_indices.push((index, subindex));` / `+field_indices.push((current_container, index, subindex));`, plus the same for the two `FIRST_VARIANT` pushes at `@@ -4010` and `@@ -4031`): the fix records the type containing each field at every step of the path. I restore the pre-fix behaviour where only the outermost container type applies to all steps (`outer_container` captured before the loop, as the old `let container` / `let mut current_container = container;` did). Nested paths (e.g. `Alpha, z.0`) now get a (container, variant, field) with the wrong container, giving wrong offsets / bad MIR.
