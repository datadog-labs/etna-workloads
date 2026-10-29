# Rationale

## Change: ext/misc/csv.c, csvtabConnect (iStart computation)
Reverses the single implementation hunk of the fix. The fix changed
`pNew->iStart = ftell(sRdr.in)` to `ftell(sRdr.in) - sRdr.nIn + sRdr.iIn`,
because the reader buffers input, so ftell() points past the buffered data
rather than at the end of the header row. In 3.54.1 the line carried an
`(int)(...)` cast; I restored the pre-fix `(int)ftell(sRdr.in)`, dropping the
`- sRdr.nIn + sRdr.iIn` correction.

## Oracle failures
test/csv01.test: 221 of 468 cases fail, including csv01-5.4 (the case the fix
added; with `header` on a real file, rows start at the wrong offset) and the
csv01-6.*.2 and csv01-7.*.2 cases that read from a file with a header.
