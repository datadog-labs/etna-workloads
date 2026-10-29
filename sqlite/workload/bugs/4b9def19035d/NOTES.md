Builds an fts5 table (detail=none, secure-delete on) with 8000 rows, optimizes it, then
overwrites the leaf block (rowid 137438953474 in t_data) with a corrupt page (from fts5corrupt9-2.x)
and deletes rowid 7999.
Clean shell: no error, prints "done". Buggy shell: memory corruption in fts5DoSecureDelete
(int varint32 truncation / unchecked memmove) -> glibc abort "malloc(): invalid size", no "done".
