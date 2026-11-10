# Re-introduced bug: default SNICallback picks the oldest matching SecureContext

**Bug.** The default `SNICallback` iterates `server._contexts` from oldest to newest and uses the first match. If `addContext()` is called again for the same hostname pattern, the older context keeps winning and the newer one is never used.

**Hunk.** The change is in `lib/internal/tls/wrap.js`, in `SNICallback`. The fix touched `lib/_tls_wrap.js`, which has since moved to this file. The fix replaced `for (const elem of contexts)` with a reverse index loop. I restored the forward `for (const elem of contexts)` loop. That brings back first-match-wins, which is the old behaviour.

**Failing test.** `parallel/test-tls-secure-context-usage-order` gives `not ok 1`. I ran it twice and it failed both times. The 'b.example.com' connection is expected to be authorized, but the stale "bad" context is used, so the assertion fails. I did not save the assertion text.
