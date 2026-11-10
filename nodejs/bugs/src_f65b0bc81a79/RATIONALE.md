# Re-introduced bug: Windows-1252 decoded as Latin-1

**Bug.** TextDecoder('windows-1252') mapped bytes 0x80-0x9F to U+0080-U+009F (Latin-1) instead of the Windows-1252 characters (e.g. 0x80 -> U+20AC '€').

**Hunk.** `lib/internal/encoding/single-byte.js`, `getEncoding()`: for `windows-1252` return an identity 256-entry map. The upstream fix replaced the Latin-1 fast path (`decodeLatin1`, simdutf latin1->utf8) with `decodeWindows1252` containing the 0x80-0x9F table. Today the release has no such fast path (windows-1252 goes through the single-byte table decoder), so the equivalent old behaviour, "windows-1252 is treated as Latin-1", is restored by making the table identity. No C++ change was possible/needed.

**Failing test.** `parallel/test-util-text-decoder` (windows-1252 special characters in 128-159 range): byte 0x80 decodes to U+0080 rather than U+20AC (assert.strictEqual failure).
