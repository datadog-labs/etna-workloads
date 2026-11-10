# Rationale

**Bug:** `StringDecoder.write()` of a UTF-8 buffer whose string would exceed V8's max string length made
`String::NewFromUtf8` return an empty MaybeLocal *without* a pending exception. The decoder returned that empty
handle without throwing, so no `ERR_STRING_TOO_LONG` reached JS (crash/undefined behaviour or silent success).

**Change (src/string_decoder.cc, `MakeString`):** corresponds to the fix's single implementation hunk. In the
current code the fix's `if (utf8_string.IsEmpty()) ThrowException(ERR_STRING_TOO_LONG)` logic lives as an up-front
`length > kMaxLength` check that throws. I replaced it with the pre-fix behaviour: for UTF8, return
`String::NewFromUtf8(...)` directly, with no ERR_STRING_TOO_LONG thrown on an empty result. Other encodings are unchanged.
(The `node_errors.h` include is still used elsewhere in the file, so it was left alone.)

**Failing test:** `parallel/test-string-decoder` fails (stable on 2 runs):
`AssertionError [ERR_ASSERTION]: Missing expected exception.` at test-string-decoder.js:205
(the `Buffer.alloc(0x1fffffe8 + 1)` ERR_STRING_TOO_LONG assertion).
