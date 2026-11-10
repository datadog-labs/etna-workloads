# Rationale

**Bug:** `SecureContext::Reset()` unconditionally decremented the external memory accounting by `kExternalSize`, even when `ctx_` was null (the context was never initialised, e.g. a failed/aborted TLS connection, or Reset called twice). The increment only happens when `ctx_` is created, so the counter went negative.

**Change (src/crypto/crypto_context.cc, `SecureContext::Reset`):** removed the `if (ctx_ != nullptr)` guard so the `external_memory_accounter()->Decrease(..., kExternalSize)` always runs. This corresponds to the fix's single implementation hunk in `src/node_crypto.h` (which added that guard); today's code lives in crypto_context.cc and uses the external memory accounter instead of `AdjustAmountOfExternalAllocatedMemory`.

**Failing test:** `parallel/test-gc-tls-external-memory` -> `not ok`, with `# Fatal error in , line 0` (the debug build aborts on the negative external-memory accounting). Failed in two consecutive runs.
