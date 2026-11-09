# Rationale
One hunk, `tree/src/compiler/checker.ts`, `getCandidateSignaturesForStringLiteralCompletions`: removed the second pass (`runWithoutResolvedSignatureCaching` with normal inference) and the merging of its candidates.
This corresponds to fix.diff's stringCompletions.ts hunk and the checker `getResolvedSignatureForStringLiteralCompletions` hunk. The fix added a fallback to normal resolved-signature completions when the inference-blocked one yielded none. Today's code merges both passes in the checker. Without the second pass, completions depend only on the signature resolved with inference blocked, which is the pre-fix behaviour.
The other fix hunks (wildcardType, skip-direct-inference) have been refactored into `blockedStringType` and have no direct counterpart.

Final: SUMMARY: 1/1 oracle cases failing (1 fix-added).
