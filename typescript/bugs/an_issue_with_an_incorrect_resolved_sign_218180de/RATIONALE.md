# Rationale
Single hunk in `tree/src/compiler/checker.ts`, in `resolveCall`. The fix's hunk added, after `resolveSignature`, a check "if `links.resolvedSignature !== resolvingSignature` then reuse the cached signature instead of the locally computed result". In v6.0.3 that logic lives in `resolveCall` as an early `return links.resolvedSignature` block. I removed the block, so the locally computed result is returned even when an inner resolution already cached a different signature. The result is an incorrect resolved signature for contextually dependent nested generic calls.

Note: that block also carries a later-added second purpose (circular re-entry); removing it removes both.

Final check.sh summary: SUMMARY: 1/1 oracle cases failing (1 fix-added). The fix-added test quickInfoNestedGenericCalls.ts fails with the wrong quick info (`<"foo", "foo">` instead of `<unknown, string>`).
