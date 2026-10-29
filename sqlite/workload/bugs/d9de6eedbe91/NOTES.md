repro.sql loads the corrupt FTS5 database from fts5corruptB test 4.0 (via `.open --hexdb`) and runs `DELETE FROM t WHERE rowid = 1;` (secure-delete path, test 4.1).
Clean shell: `Error near line 193: fts5: corruption in table "t"`, exit status 1.
Buggy shell: the delete is silently accepted (exit 0), because the corrupt index offsets are not bounds-checked (buffer overrun in fts5DoSecureDelete).
