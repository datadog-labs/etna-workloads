# Adapted injection for fix error when a dangling ref in a ManuallyDrop is used in a pattern

Fix: https://github.com/rust-lang/rust/commit/c22fbbe5828ce64a857bc0267c71ac9381143e6a

# Rationale
File compiler/rustc_middle/src/diagnostics.rs (moved from error.rs in 1.99.1), struct InvalidConstInValtree.
Re-expresses the only implementation hunk, `@@ -137,7 +137,9 @@ pub(crate) struct MaxNumNodesInValtree`:
the `#[note(...)]` was changed to "...memory or that contain dangling references cannot be used as patterns".
Reinjected: note reverted to "constants that reference mutable or external memory cannot be used as patterns", so the diagnostic omits the dangling-reference case (the oracle .stderr files expect the new wording).
