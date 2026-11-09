# Rationale
One hunk, `src/compiler/checker.ts` in `checkExpressionWorker`, string literal case. It corresponds to the single hunk of fix.diff.
The fix made string literals with the skip-direct-inference flag return a blocking type (`anyType` then, `blockedStringType` today). I removed that check, so those literals again return a fresh string literal type. Direct inference from them then affects contextual signatures, so string completions that depend on a context-sensitive signature are lost.

Final check.sh: SUMMARY: 1/1 oracle cases failing (1 fix-added).
