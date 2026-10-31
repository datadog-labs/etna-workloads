# Rationale

Hunk changed: `_PyErr_ProgramDecodedTextObject` in `Python/errors.c`.

The fix added a block that, when no encoding is given, detects the source file's
encoding (`_PyTokenizer_FindEncodingFilename`, falling back to "utf-8") and rewinds
the file. I removed that block, so a NULL encoding now always becomes "utf-8". The
`PyErr_ProgramTextObject` path therefore ignores `# coding:` cookies, which is the
"Detect source file encoding" bug the fix addressed. The other fix hunks (BOM skip,
replace handler, NUL-safe length, head of long lines) are left in place.

Failing oracle case: `test_exceptions.SyntaxErrorTests.test_file_source`. For a
latin1 file with a coding cookie, the traceback shows `return "�"` instead of
`return "ä"`.
