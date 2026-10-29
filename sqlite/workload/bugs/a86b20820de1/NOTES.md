Reproducer for fts3corrupt4-12.1: loads the corrupt 4096-byte-page FTS3 database from the test
(via `.open --hexdb`) and runs `matchinfo(t1,'pcxybspcxybs') ... MATCH 'e*e*'`.

Clean shell: `Error near line 279: database disk image is malformed` (exit 1).
Buggy shell: fts3PoslistMerge no longer rejects a zero column number, so it loops forever (hang, killed by timeout).
