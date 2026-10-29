`repro.sql` runs `SELECT strftime();` (zero arguments; fuzz2-6.2).
The injection removes the `if( argc==0 ) return;` guard in strftimeFunc, so argv[0] is read with no arguments.
Clean shell: prints an empty row, exit 0. Buggy shell: segfault (exit 139).
