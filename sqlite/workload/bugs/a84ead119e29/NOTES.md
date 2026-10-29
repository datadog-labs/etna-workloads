Creates a trigger, then runs CREATE TRIGGER IF NOT EXISTS with the same name and a body containing two RETURNING clauses.
Clean shell: the statement is a no-op and prints `done`. Buggy shell: an assert() in sqlite3AddReturning fires (the parser sees a second RETURNING while bReturning is set), so the shell aborts.
