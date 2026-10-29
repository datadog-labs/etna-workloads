Inserts a row into a table with a FOREIGN KEY via `INSERT ... SELECT` from an identically-shaped table, with foreign_keys=ON and a violating value (234 not in parent).
Clean shell: "FOREIGN KEY constraint failed" and t7b stays empty. Buggy shell: the transfer optimization is used, skipping FK checks, so the insert succeeds and t7b contains 234.
