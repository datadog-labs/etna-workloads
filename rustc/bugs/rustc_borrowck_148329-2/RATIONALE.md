# Adapted injection for Do not propogate unnecessary closure constraints + tests.

Fix: https://github.com/rust-lang/rust/commit/29ad85c116b40f8c72305074d52087831af02485

# Rationale
File: compiler/rustc_borrowck/src/region_infer/mod.rs, fn `try_propagate_universal_region_error`.
Fix hunk `@@ -1292,6 +1292,26 @@` added a filter (`subset ... .filter(eval_outlives(fr_minus, fr_plus))`, falling back to the full set if empty) so only `shorter_fr+` regions already outlived by `fr-` get propagated. On 1.99.1 this lives as a filter over `constraints` producing `subset`; I removed it and use `let propagated_constraints = constraints;`, so all `fr-: shorter_fr+` constraints are propagated (the old bug).
