# Re-introduced bug: http content-disposition header not latin1-encoded (PR #46528)

**Bug.** When `Content-Length` is set, a `content-disposition` header value that holds
non-ASCII (binary/latin1) characters was written as UTF-8 by `OutgoingMessage`, so each byte
>0x7f was double-encoded. The fix treated such values as latin1 so the bytes go out unchanged.
The same code path applies to the non-array and array header forms.

**Change (lib/_http_outgoing.js).**
1. Removed the block at the top of `processHeader()` that, for `content-disposition` with
   `self._contentLength`, converted the value (or each array element) with
   `Buffer.from(v, 'latin1')`. Corresponds to the fix's `processHeader` hunk (today's code also
   handles array values, hence the loop). Without it the string is written as UTF-8 again.
2. Removed the now-unused helper `isContentDispositionField()`. Corresponds to the fix's helper hunk.

**Failing test.** `parallel/test-http-server-non-utf8-header` fails (stable over 2 runs):
the content-disposition header is received as `'bÃ\x83Â¥r'` instead of the expected `'bÃ¥r'`.
