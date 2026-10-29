Reproducer for shared3-1.2 (ticket #1824): the encoding flag of a shared-cache schema gets reset to UTF-8 when a new connection opens.
`repro.sh` makes a UTF-16 database, then opens it on a second and third shared-cache connection (`.open file:t.db?cache=shared` with `.connection N`).
Clean shell: `abc|This is a test string` and `This is a test string`. Buggy shell: the third connection returns garbage, `a|T`.
