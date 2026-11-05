CREATE TEMP TABLE foo (f1 int, f2 text);
INSERT INTO foo VALUES (1,'a'),(2,'b');
CREATE TEMP VIEW foo_v AS SELECT * FROM foo OFFSET 0;
UPDATE foo SET f2 = foo_v.f2 FROM foo_v WHERE foo_v.f1 = foo.f1 RETURNING foo_v;
