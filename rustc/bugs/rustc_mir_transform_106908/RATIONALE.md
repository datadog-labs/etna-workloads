# Adapted injection for Do not merge locals that have their address taken.

Fix: https://github.com/rust-lang/rust/commit/d29dc057ba53063a9ce7f1b307a89759a096f4ac

# Rationale
File compiler/rustc_mir_transform/src/ssa.rs, fn compute_copy_classes: removed the
`if ssa.borrowed_locals().contains(local) { continue; }` guard (with its comment about address not
being observable). Re-expresses fix.diff's theme (`@@ -21,19 +20,23 @@ impl SsaLocals`, passing `borrowed_locals`
into SsaLocals and `@@ -110,8 +... visit_place`: "We observe the address of `place.local`. Do not replace it"),
i.e. "Do not merge locals that have their address taken". In 1.99.1 that logic lives in this guard, so
without it a borrowed local is merged with its copy source, making addresses compare equal.
