# Rationale

## Objects/unicode_writer.c: `_PyUnicodeWriter_WriteSubstring()`
The function moved from unicodeobject.c to unicode_writer.c. The fix replaced the
early `if (end == 0) return 0;` with a `len = end - start; if (len == 0) return 0;`
check placed after the whole-string shortcut. I restored the old early exit
(`end == 0`) and removed the `len == 0` check. Only `end == 0` is now treated as
empty, so `start == end > 0` (e.g. `write_substring("abc", 1, 1)`) falls through to
`_PyUnicodeWriter_Prepare(writer, 0, maxchar)` and a zero-length copy, which is the
crash the fix addressed.

## Oracle
`PyUnicodeWriterTest.test_substring_empty` fails. The run also crashes (an assertion or
crash in the process), so other PyUnicodeWriterTest cases (test_ucs4, test_utf8,
test_widechar, test_write_char, test_write_latin1) are reported failing as an
incomplete run.
