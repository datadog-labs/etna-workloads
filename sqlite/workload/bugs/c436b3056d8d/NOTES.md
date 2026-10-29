repro.sql ports fts5corrupt6-1.1. It builds an fts5 table with 1000 rows. It then overwrites the first two bytes of one `ft_data` leaf block with 0x4e20, which is a bogus first-rowid offset of 20000. Finally it runs a descending-rowid query on `ft('def')`.

- clean: `Error near line 11: database disk image is malformed`, exit status 1.
- buggy: no error, exit status 0. `fts5SegIterReverseNewPage` skips the `iRowidOff>=szLeaf` check, so it reads out of bounds without noticing the corruption.
