`repro.sql` is the body of fts3prefix2-1.3. It uses a 512-byte page size and an FTS4 table with `prefix="2,3"`. It fills the table with 2048 identical rows, inserts 30 more, and deletes the rows with docid > 5. Then it runs `MATCH 'T*'`.

- clean: exit status 0, and the query returns 5 rows.
- buggy: the query returns the 5 rows but also prints `Error near line 21: database disk image is malformed`, and the exit status is 1.

The injection makes the segment reader for a 1-character prefix queried through the 2-character prefix index stop using the lookup-only flag (`bLookup`), so it keeps reading past the term it should stop at.
