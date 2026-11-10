# Adapted injection for Simply do not ICE

Fix: https://github.com/rust-lang/rust/commit/994d55158dcfe0b1b299591bb552af14c63c6e60

# Rationale
File: compiler/rustc_trait_selection/src/solve/fulfill.rs, `FulfillmentCtxt::try_evaluate_obligations`, overflow branch.
Re-expresses fix hunk `@@ -109,7 +109,10 @@` which replaced `unimplemented!("overflowed on pending obligations: {:?}", self.obligations);` with returning accumulated errors. On 1.99.1 the code moved; the overflow branch now records overflowed obligations and returns errors. I restore the old `unimplemented!("overflowed on pending obligations: ...")` ICE there.
