# Adapted injection for Add note when matching on tuples/ADTs containing non-exhaustive types

Fix: https://github.com/rust-lang/rust/commit/82ce7b14613c4703e2a21775c60c578ac9246db2

# Rationale
File: compiler/rustc_mir_build/src/thir/pattern/check_match.rs, fn `non_exhaustive_match`.
The fix hunk `@@ -717,22 +729,27 @@ fn non_exhaustive_match` replaced the old condition
`scrut_ty == usize/isize && !is_empty_match && witnesses.len() == 1 && NonExhaustive`
with a walk over the witness collecting nested non-exhaustive types (`collect_non_exhaustive_tys`).
In 1.99.1 the walk is `collect_special_tys`; I re-added the old restriction in the pointer-sized-int branch:
the note is emitted only if the special type equals `scrut_ty` and there is exactly one witness, so
tuples/ADTs containing usize/isize no longer get the note.
