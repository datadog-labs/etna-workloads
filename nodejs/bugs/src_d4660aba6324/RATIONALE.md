# Rationale

**Bug:** `Fill()` in src/node_buffer.cc parsed `start`/`end` with `Uint32Value`, truncating to 32 bits. Buffers >2**32 can't be filled correctly, and negative values (e.g. -1) wrap around to huge uint32 values instead of raising ERR_OUT_OF_RANGE (the binding returned -2 via the OOB check).

**Change (single hunk, src/node_buffer.cc `Fill`):** corresponds to the fix's only implementation hunk. Replaced `size_t start/end` obtained through `THROW_AND_RETURN_IF_OOB(ParseArrayIndex(...))` with `uint32_t start/end` read via `args[N]->Uint32Value(ctx).To(&x)`. Today's code had `size_t start = 0;` (initialised), so the hunk was re-expressed on that.

**Failing test:** parallel/test-buffer-fill — `AssertionError [ERR_ASSERTION]: Missing expected exception.` (internalBinding('buffer').fill(Buffer.alloc(1), 1, -1, 0, 1) no longer throws ERR_OUT_OF_RANGE; it returns -2 instead). Failure was stable across two runs.
