repro.sql loads the corrupt FTS3 database from fts3corrupt7 test 9.0 via `.open --hexdb` and runs `PRAGMA integrity_check`.
Clean shell: prints "malformed inverted index for FTS3 table main.t" and exits 0.
Buggy shell: the checksum loop doesn't detect the corrupt doclist (bad position varint) and never terminates; it hangs (check.sh reports a timeout).
