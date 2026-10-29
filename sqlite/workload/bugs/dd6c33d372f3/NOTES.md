repro.sql runs `SELECT printf('%.*g',2147483647,0.01);`.
Clean shell: prints 0.01, exit 0.
Buggy shell: no precision cap on float conversions, so it fails with "string or blob too big", exit 1.
