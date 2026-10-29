repro.sql: indexed column, LIKE pattern with a leading quote character (`'''a%'`), which triggers the LIKE prefix optimization.
Clean shell returns `'abc` and `'ax`. The buggy shell dequotes the prefix a second time and hits an assertion failure in sqlite3Dequote (abort, exit -6).
