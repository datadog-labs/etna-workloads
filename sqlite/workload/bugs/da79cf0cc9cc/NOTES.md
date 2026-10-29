repro.sql is the setup and both queries from tkt-54844eea3f-1.1/1.2: correlated sub-queries in FROM.
With the bug, automatic indexes are built on the correlated sub-query and are reused across outer rows.
Clean: `test-2|2|0`, `test-2|3|0`, and the last column is `,two,,four`.
Buggy: `test-2|2|1`, `test-2|3|1`, and the last column is `,two,,two`.
