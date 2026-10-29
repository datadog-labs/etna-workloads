Reproducer: repro.sql. It builds a tokendata=1 fts5 table, overwrites its %_data shadow rows with the corrupt records from fts5vocab2-6.0 (`.dbconfig defensive off` is needed to allow that), then scans an fts5vocab 'row' table over it.

Clean shell: "Error near line 10: database disk image is malformed", exit 1.
Buggy shell: assertion failure `nTerm>=0` in fts5VocabNextMethod, abort (exit -6). The injection removed the code that turns off tokendata for SCAN/NOTOKENDATA queries.
