CREATE TABLE foo (f1 int, f2 text, f3 int, f4 int);
UPDATE foo SET f4 = 1;
INSERT INTO foo VALUES (6, 'p', 60, 600) RETURNING old, (old).f4, (old).*, new, (new).f4;
UPDATE foo SET f4 = 700 WHERE f1 = 6 RETURNING (old).f4, (new).f4, (old).*;
