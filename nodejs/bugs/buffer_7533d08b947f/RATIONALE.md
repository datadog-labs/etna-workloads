# atob validation regression (nodejs/node 7533d08)

**Bug:** `atob` did not reject input whose count of non-whitespace characters is `% 4 === 1` (e.g. `atob('a')`, `'a\n\n\n'`, `'\ta\r \n\f'`), contrary to step 3 of the WHATWG forgiving-base64 decode. It silently returned a (truncated) decoded string instead of throwing `InvalidCharacterError`.

**Change (lib/buffer.js, one hunk):** In today's code, validation is done by simdutf in `_atob`; the fix's new `% 4 === 1` check corresponds to the `-1` ("single character remained", BASE64_INPUT_REMAINDER) case in `atob()`. Instead of throwing the DOMException, that case now falls back to `Buffer.from(input, 'base64').toString('latin1')`, which is what the pre-fix code returned when it lacked the check. The invalid-character check (the other pre-fix part) is kept.

**Failing test:** `parallel/test-btoa-atob` -> `not ok` (stable over 2 runs); the `throws(() => atob(value), { name: 'InvalidCharacterError', ...})` assertions fail for `'a'` etc. because nothing is thrown.
