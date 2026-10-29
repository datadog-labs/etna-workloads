repro.sh: in a UTF-16 database, creates virtual tables named with malformed UTF-8 bytes (\xC8, \xC9, which both become U+FFFD).
Clean: second CREATE fails with "malformed database schema ... table ... already exists" (exit 1).
Buggy: the VCreate P4 name is not the converted name, so sqlite3VtabCallCreate hits an assertion failure (abort, exit 134).
