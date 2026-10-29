repro.sql creates an `fts5vocab` table backed by a table named `nosuchtable`
that does not yet exist, then creates `nosuchtable` as an FTS3 table and
inserts a row into it, and finally queries the `fts5vocab` table.

fts5vocab resolves its backing table lazily, by name, each time it is
queried. At query time `nosuchtable` exists but is an FTS3/4 table, not an
FTS5 table, so `sqlite3Fts5IndexFromCsrid()` fails to find a matching FTS5
cursor/table (`fts5CursorFromCsrid()` returns NULL) and must report "no
such fts5 table".

- fixed (`sqlite3-clean`): checks `pCsr` for NULL before dereferencing it,
  so the lookup fails gracefully and the query returns the error
  `no such fts5 table: main.nosuchtable` (exit status 1).
- buggy (`sqlite3-buggy`, with `injection.patch` applied): the NULL check
  is removed, so the code dereferences the NULL `pCsr` pointer and the
  shell crashes with a segmentation fault (exit status -11).

This corresponds to upstream fts5vocab2.test cases 4.3.3, 5.0-5.2, 6.0-6.2,
7.0-7.1, 8.0-8.1, which all exercise this same NULL-dereference path.
