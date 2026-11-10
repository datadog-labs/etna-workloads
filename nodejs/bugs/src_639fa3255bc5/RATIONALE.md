# Rationale

**Bug:** The ICU transcoder created its target `Converter` with a hard-coded 1-byte substitution string `"?"`. For encodings whose minimum char size is >1 (e.g. UCS-2/UTF-16LE), ICU rejects this in `ucnv_setSubstChars`, so the `U_SUCCESS(status)` CHECK aborts the process (`buffer.transcode(..., 'utf16le', 'ucs2')`, issue #38330).

**Hunks** (both in `src/node_i18n.cc`):
1. `Transcode()`: restored `Converter to(toEncoding, "?");` and removed the min-char-size-based substitution (fix hunk 1 reversed).
2. `TranscodeFromUcs2()`: same (fix hunk 2 reversed). Today's code uses `to.min_char_size()` instead of `ucnv_getMinCharSize(to.conv())`, so the reversal was re-expressed.

**Failing test:** `parallel/test-icu-transcode` — aborts with `Assertion failed: U_SUCCESS(status)` in `Converter::set_subst_chars` from `transcode` (test-icu-transcode.js:89, the `SlowBuffer(1)` utf16le->ucs2 case).
