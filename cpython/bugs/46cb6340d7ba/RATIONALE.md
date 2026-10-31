# gh-127903 reintroduced

## Hunks
1. `Objects/unicodeobject.c`, `_copy_characters`: reverses the fix's only implementation hunk.
   The `assert(PyUnicode_Check(to))` and `assert(to_start + how_many <= len(to))` are
   restored before the `how_many == 0` early return, so a `to == NULL` with nothing to copy
   trips the assert on debug builds. It is the same code as the pre-fix version.
2. `Objects/unicode_writer.c`, `_PyUnicodeWriter_WriteSubstring`: removes the `if (len == 0) return 0;`
   early return. This is the other path, which was not in the fix. In v3.15.2 that early
   return keeps empty substrings from reaching `_copy_characters`, so the fix's case no longer
   crashed. With it gone, an empty substring on a fresh writer
   (`_PyUnicodeWriter_Prepare(writer, 0, ...)` leaves `writer->buffer == NULL`) calls
   `_PyUnicode_FastCopyCharacters(NULL, ...)` with `how_many == 0`. That is the
   situation the fix handled. `datetime.strftime('%z')` reaches it through `wrap_strftime`,
   which writes the empty substring before `%z`.

## Oracle
`test_str.StrTest.test_issue127903` fails: `d.strftime('%z')` aborts on the
`PyUnicode_Check(to)` assert in `_copy_characters`. Because the process aborts, the later
cases in the run are reported as failing too (incomplete run).
