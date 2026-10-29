Reproducer (`repro.sh`): on a file DB, set exclusive locking and PERSIST journal, create an fts5 table, then run an fts5 integrity-check and read `PRAGMA data_version` before/after (mirrors fts5integrity-8.x).

Clean: data_version stays 1 after the integrity-check. Buggy: it prints 0, because the injection bumps iDataVersion after the commit check instead of at its start, so the value differs.
