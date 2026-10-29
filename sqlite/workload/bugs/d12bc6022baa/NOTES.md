repro.sql opens a temp database (`.open ""`), sets cache_size=1 and auto_vacuum=2 (incremental), and creates tables with 800-byte rows so pages spill. Creating t2 triggers sqlite3PagerMovepage() on a spilled temp page.
Clean shell: prints `ok`, exit 0. Buggy shell: assertion failure `pPgOld` in sqlite3PagerMovepage (abort, exit -6).
