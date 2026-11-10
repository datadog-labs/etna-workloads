# Re-introduced bug (nodejs/node#44324)

Bug: the V8 flag `--disallow-code-generation-from-strings` is ignored. Node sets the context's
IsCodeGenerationFromStringsAllowed to false at snapshot-build time and stores `true` in embedder data, so
`node::ModifyCodeGenerationFromStrings` always sees "allowed" and eval is permitted despite the flag.

Hunks:
1. `src/api/environment.cc` `InitializeContextRuntime`: removed the block that reads
   `context->IsCodeGenerationFromStringsAllowed()` (refreshed by the V8 flag), sets it to false and propagates
   the value to embedder data (fix hunk 1, reversed). Embedder data therefore stays at the snapshot default `true`.
2. `src/api/environment.cc` `InitializeMainContextForSnapshot`: restored the old
   `AllowCodeGenerationFromStrings(false)` + embedder data `true` (fix hunk 2, reversed).
3. `src/node_snapshotable.cc`: removed `ResetContextSettingsBeforeSnapshot` and its two calls (fix hunks 3-5, reversed),
   so the flag is no longer reset to default before serialization.

Failing test: `parallel/test-eval-disallow-code-generation-from-strings` ("not ok": eval does not throw EvalError,
assert.throws reports missing expected exception). `parallel/test-eval` still passes. Failure confirmed stable over two runs.
