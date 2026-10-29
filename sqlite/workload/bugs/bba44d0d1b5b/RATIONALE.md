# Rationale

Changed: `ext/fts3/fts3_write.c`, `fts3DeleteByRowid()`, in the `isEmpty` branch.

Fix hunk reversed: the one that, when deleting the last row empties the table, sets
`*pnChng = 0` and zeroes `aSzDel` (the `memset(aSzDel, 0, ...)`). Before the fix, the
empty-table case simply decremented the document count (`*pnDoc = *pnDoc - 1`) and did not
discard the sizes of the deleted document. I restored that: `*pnChng = *pnChng - 1`, no memset.
fts3DeleteAll() already cleared the doc totals. fts3UpdateDocTotals() then applies the
stale deletion (-1 doc, -sizes) on top of the cleared totals, so the "number-of-documents"
field and the sizes in the %_stat row are wrong.

Oracle failures (fts3conf.test): 3.4, 3.5, 3.6 ("database disk image is malformed" from
the corrupt stat record) and 3.8 (matchinfo 'na' returns 1 doc instead of 2).
