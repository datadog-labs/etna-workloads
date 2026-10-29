repro.sh builds a 1024-byte-page db, runs a second write, then restores header bytes 28 (db size) and 92-99 (change counter/version-valid-for) to simulate a pre-3.7.0 writer that grew the file without updating the size field.
It then opens a write transaction (INSERT INTO t2).

Clean: the write transaction refreshes the header size field (0x10) and integrity_check reports ok.
Buggy: the header size stays 9 and integrity_check reports corruption (invalid page numbers, "malformed"), exit status 1.
