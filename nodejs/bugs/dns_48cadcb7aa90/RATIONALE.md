# Re-introduced bug: DNS TXT string built from NUL-terminated data

**Bug.** `ParseTxtReply` in `src/cares_wrap.cc` built the JS string for each TXT chunk with `OneByteString(isolate, current->txt)`. That call has no length, so it treats the data as NUL-terminated. A TXT record containing an embedded `\0` is truncated at the first NUL, or garbled. The length c-ares reports is ignored.

**Hunk (`src/cares_wrap.cc`, `ParseTxtReply`).** This corresponds to the fix's only implementation hunk. The call is changed back from `OneByteString(env->isolate(), current->txt, current->length)` to `OneByteString(env->isolate(), current->txt)`. The surrounding code has moved since the fix, so this is re-expressed against the current code.

**Failing test.** `parallel/test-dns-resolveany` fails. It expects the TXT entry `'xyz\0foo'` and gets `'v=spf1 ~all xyz'`. The diff reports `+ 'v=spf1 ~all xyz'` against `- 'v=spf1 ~all xyz\x00foo'`.
