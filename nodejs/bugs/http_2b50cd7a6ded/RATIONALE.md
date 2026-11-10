# Rationale

**Bug:** `http.ServerResponse#write` (and OutgoingMessage.write) rejected plain `Uint8Array`s with `ERR_INVALID_ARG_TYPE`, because chunk validation used `chunk instanceof Buffer` instead of accepting any Uint8Array, even though the error message lists Uint8Array as valid.

**Change (lib/_http_outgoing.js, `write_`):** the validation `!isUint8Array(chunk)` became `!(chunk instanceof Buffer)`. This corresponds to the fix's hunk replacing `chunk instanceof Buffer` with `isUint8Array(chunk)` (today's code is restructured into a single up-front check, so the reversal was applied there). The `isUint8Array` import is still used elsewhere, so nothing else changes.

**Failing test:** parallel/test-http-outgoing-write-types — `TypeError [ERR_INVALID_ARG_TYPE]: The "chunk" argument must be of type string or an instance of Buffer or Uint8Array. Received an instance of Uint8Array` at `res.write(new Uint8Array(1024))`. Failure was stable across two runs.
