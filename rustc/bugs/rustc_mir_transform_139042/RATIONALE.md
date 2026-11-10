# Adapted injection for Do not optimize out SwitchInt before borrowck, or if Zmir-preserve-ub

Fix: https://github.com/rust-lang/rust/commit/3ee62a906e8a025834d11c46b8c2f133d3a12448

# Rationale
Only `compiler/rustc_mir_transform/src/simplify.rs`, `CfgSimplifier::new`, changed.
The fix hunk `@@ -110,9 +118,12 @@ impl<'a, 'tcx> CfgSimplifier<'a, 'tcx>` added
`let preserve_switch_reads = matches!(body.phase, MirPhase::Built | MirPhase::Analysis(_)) || tcx.sess.opts.unstable_opts.mir_preserve_ub;`,
which `simplify_branch` (hunk `@@ -253,9 +264,15 @@`, `if self.preserve_switch_reads { return false; }`) checks.
I set it to a constant `false`, so trivial SwitchInt terminators are again collapsed on built/analysis MIR and under -Zmir-preserve-ub.
The other fix hunks are plumbing (tcx args, option rename) and were left as is.
