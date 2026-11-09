# Rationale
One hunk, in `src/services/utilities.ts` `documentSpansEqual`: corresponds to the fix's hunk of the same function.
The fix made file-name comparison honour `useCaseSensitiveFileNames`; I restored the original `a.fileName === b.fileName`
(always case-sensitive), leaving the parameter in place so existing callers still type-check. Paths differing only
in case are therefore not deduplicated on case-insensitive hosts (duplicate rename/reference results).

Final: SUMMARY: 1/11 oracle cases failing (1 fix-added).
