# Rationale

**Bug:** The KeyObject constructor's handle type check threw `ERR_INVALID_ARG_TYPE` with the expected type `'string'` instead of `'object'`. Passing a bad handle produced the misleading message `The "handle" argument must be of type string. Received type string ('')`.

**Hunk:** `lib/internal/crypto/keys.js` (~line 178, in the `KeyObject` constructor). It corresponds to the fix's only implementation hunk, which changed `'string'` to `'object'`. The code has since moved: it now sits inside a class and also checks `instanceof KeyObjectHandle`. I changed the expected-type argument back to `'string'`.

**Failing test:** `parallel/test-crypto-key-objects` fails. The `new KeyObject('secret', '')` check gets the message `The "handle" argument must be of type string...` where it expects `...of type object...`. It failed on both runs.
