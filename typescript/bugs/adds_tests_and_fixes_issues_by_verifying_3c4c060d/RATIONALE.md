# Rationale
One hunk, in `tree/src/services/services.ts`. It corresponds to the `services.ts` hunk of fix.diff.

- `cleanupSemanticCache` goes back to only setting `program = undefined`. The release of the document-registry entries moves back into `dispose()`.
- The fix had moved that release into `cleanupSemanticCache`, so language-service ref counts were dropped whenever the cache was cleaned.
- With the bug, `cleanupSemanticCache` (called from `clearSemanticCache`, `disableLanguageService` and the session's cleanup) leaks the ref counts. The document registry then reports unexpected language service ref counts, for example `TS 3` where `TS 1` was expected.
- The other fix hunks are not re-injected. They are mostly test-support code such as the verifier hooks and the `getBuckets` accessor.

Final ./check.sh summary line: SUMMARY: 15/121 oracle cases failing (0 fix-added).
