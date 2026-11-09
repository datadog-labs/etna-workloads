# Rationale
All hunks are in `tree/src/compiler/utilities.ts` (the parser.ts hunks of fix.diff only threaded `sourceText` through; today's code still passes it, which is harmless).

1. `createDetachedDiagnostic`: removed the clamp `if (start + length > sourceText.length) length = sourceText.length - start;` (fix.diff hunk in createDetachedDiagnostic). Detached diagnostics can again run past the end of the file.
2. `assertDiagnosticLocation`: restored the optional-source form (`sourceText: string | undefined`, upper-bound checks only when defined), and the detached call passes `undefined` as before the fix, so the detached diagnostic isn't checked at creation. The overrun now surfaces later in `attachFileToDiagnostic` ("Expected 22 <= 21") for parseUnmatchedTypeAssertion.

Final check.sh: SUMMARY: 6/6 oracle cases failing (6 fix-added).
