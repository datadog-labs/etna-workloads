# Rationale

**Bug:** `Buffer.concat(list)` with a non-array `list` threw ERR_INVALID_ARG_TYPE whose message
claimed `list` could be "Array, Buffer, or Uint8Array", although only an Array is accepted.

**Change (lib/buffer.js):**
- Hunk 1 corresponds to the fix's lib/buffer.js hunk. Today's code uses `validateArray(list, 'list')`; I replaced it with
  `if (!ArrayIsArray(list)) throw new ERR_INVALID_ARG_TYPE('list', ['Array','Buffer','Uint8Array'], list)`,
  the pre-fix form, restoring the misleading message.
- Hunk 2 removes the now-unused `validateArray` import (needed to avoid an unused-variable lint error).

**Failing test:** parallel/test-buffer-concat:
`The "list" argument must be an instance of Array, Buffer, or Uint8Array. Received undefined`
vs expected `The "list" argument must be an instance of Array. Received undefined`.
