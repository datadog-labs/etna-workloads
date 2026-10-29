Reproducer (repro.sql): mirrors fts5misc-4.3/4.4. Creates an fts5 table with one row, then runs two
'rebuild' commands in one transaction, commit, then 'integrity-check'.
Clean shell: no output, exit 0. Buggy shell: "database disk image is malformed" from integrity-check, exit 1
(rebuild no longer discards pending index data / invalidates cached totals).
