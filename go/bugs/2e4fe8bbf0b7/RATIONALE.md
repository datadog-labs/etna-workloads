# Rationale

Fix reversed (types2/infer.go hunk): the fix removed the `allowVersion(go1_21)` gate around the
"maximum untyped type" logic in `infer`. I restored the gate in
`src/cmd/compile/internal/types2/infer.go` step 3: for go1.21+ the max-untyped logic runs; otherwise
the old logic runs, which unifies each remaining type parameter with the default type of its untyped
argument and reports the "default type" mismatch via `errorf` (adapted to the current
`errorf(tpar, targ, arg)` / `err.addf` signature). The poser dance (`at`) is not needed because
`allowVersion` now takes no position.

The go/types hunk is not reproduced: go/types is outside src/cmd/compile. The test-data hunk is a test file.

Oracle failures: `TestExamples` and `TestExamples/inference.go`. inference.go has no version
directive, and the types2 test configuration therefore evidently checks it below go1.21. So
`min(1, 2.3)` and `min(1.2, 3)` again report "default type ... does not match", where the fixed
tests expect them to be accepted.
