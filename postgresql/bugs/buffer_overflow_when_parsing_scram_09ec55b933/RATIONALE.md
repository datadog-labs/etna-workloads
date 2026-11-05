# Rationale

## Changed hunk

**File:** `src/src/backend/libpq/auth-scram.c`
**Function:** `parse_scram_secret()`

**Traces to fix.patch/fix_impl.patch hunk:**

```
-	if (pg_b64_dec_len(strlen(storedkey_str) != SCRAM_KEY_LEN))
-		goto invalid_verifier;
+	decoded_stored_buf = palloc(pg_b64_dec_len(strlen(storedkey_str)));
 	decoded_len = pg_b64_decode(storedkey_str, strlen(storedkey_str),
-								(char *) stored_key);
+								decoded_stored_buf);
 	if (decoded_len != SCRAM_KEY_LEN)
 		goto invalid_verifier;
+	memcpy(stored_key, decoded_stored_buf, SCRAM_KEY_LEN);
```
(and the analogous hunk for `serverkey_str`/`server_key`).

The original fix changed `parse_scram_verifier()` (now `parse_scram_secret()`
after later refactoring) so that the base64-decoded StoredKey/ServerKey are
first decoded into a `palloc`'d scratch buffer sized to the actual decoded
length of the *input* string, and only afterwards `memcpy`'d into the
fixed-size `SCRAM_KEY_LEN`-byte `stored_key`/`server_key` output buffers
(copying only `*key_length` bytes). Before the fix, the code decoded
straight into the fixed-size `stored_key`/`server_key` buffers while basing
the "is this the right size" check on a parenthesization bug that didn't
actually bound the decoded length, allowing a maliciously long/over-encoded
StoredKey/ServerKey field in a stored SCRAM verifier to overflow the
caller-supplied `stored_key`/`server_key` buffers.

In today's (REL_18_6) code, `parse_scram_secret()` already uses the current
4-argument `pg_b64_decode(src, len, dst, dstlen)` API, which takes an
explicit `dstlen` and enforces it internally, and the fix is expressed as
decoding into local `decoded_stored_buf`/`decoded_server_buf` scratch
buffers sized by `pg_b64_dec_len(strlen(...))`, then `memcpy`-ing only
`*key_length` bytes into the real `stored_key`/`server_key` buffers.

To re-introduce the bug while remaining faithful to the same logical flaw
(decoding attacker-controlled-length base64 data directly into the
fixed-size key buffers, sized only by the *destination* capacity rather
than being routed through a correctly-sized scratch buffer), the scratch
buffers and intermediate `memcpy` are removed, and `pg_b64_decode` is called
directly on `stored_key`/`server_key`, passing `decoded_len =
pg_b64_dec_len(strlen(storedkey_str/serverkey_str))` (a value derived from
the *input* string's length) as the `dstlen` argument — rather than the
actual allocated size of the destination buffer (`*key_length` /
`SCRAM_KEY_LEN`). Since `stored_key` and `server_key` are fixed
`SCRAM_KEY_LEN`-byte buffers supplied by the caller (not re-allocated to
match `decoded_len`), an attacker-crafted SCRAM verifier whose StoredKey or
ServerKey field decodes to more than `SCRAM_KEY_LEN` bytes causes
`pg_b64_decode` to write past the end of the `stored_key`/`server_key`
buffer — reproducing the original buffer overflow with the current
`pg_b64_decode` API.

## Oracle result

```
running src/test/regress  ...
FAIL  src/test/regress||password  ['fail']
oracle cases failing: 1/1
```

The `src/test/regress||password` oracle case fails with this change, as
required. With no change (clean tree), it passes.
