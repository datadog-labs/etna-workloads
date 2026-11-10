# crypto: fix unsigned conversion of 4-byte RSA publicExponent

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit bad1e2fe6a82216f03830e00f12e85b6d6647cf0 applied to v26.13.0 (clean).

Upstream commit message:

```
crypto: fix unsigned conversion of 4-byte RSA publicExponent

`bigIntArrayToUnsignedInt` used the signed `<<` operator, so when the
most significant byte of a 4-byte input had its top bit set (e.g.
`[0x80, 0x00, 0x00, 0x01]`) the result was a negative Int32 instead of
the intended unsigned 32-bit value. This caused any RSA `publicExponent`
exactly 4 bytes long with the top bit set to be parsed incorrectly.
Coerce the final value with `>>> 0` and add a unit test.

Assisted-by: Claude <noreply@anthropic.com>
Co-Authored-By: Claude <noreply@anthropic.com>
Co-Authored-By: DeepView Autofix <276251120+deepview-autofix@users.noreply.github.com>
Co-Authored-By: Nikita Skovoroda <chalkerx@gmail.com>
Signed-off-by: Nikita Skovoroda <chalkerx@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/62839
Reviewed-By: Filip Skokan <panva.ip@gmail.com>
```
