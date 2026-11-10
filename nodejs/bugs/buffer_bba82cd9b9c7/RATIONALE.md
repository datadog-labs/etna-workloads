# atob input validation regression

**Bug:** `atob` rejected ASCII whitespace (space, \t, \n, \f, \r) with `InvalidCharacterError`, although the WHATWG forgiving-base64 decode algorithm says whitespace must be stripped. e.g. `atob(' ')` should be `''` and `atob('  YW\tJ\njZA=\r= ')` should be `'abcd'`.

**Change (lib/buffer.js, one hunk):** In today's code decoding is done in C++ (simdutf, which tolerates whitespace), so the fix's hunk (replacing the `kBase64Digits` string check with a forgiving allowed-chars list) is re-expressed by restoring the pre-fix pre-validation loop in `atob()` using the old `kBase64Digits` alphabet (no whitespace) before calling `_atob`. This corresponds to the fix's hunks replacing `kBase64Digits` with `kForgivingBase64AllowedChars` and the check in `atob`.

**Failing test:** `parallel/test-btoa-atob` (not ok, stable over 2 runs): `atob(' ')` throws `InvalidCharacterError: Invalid character`.
