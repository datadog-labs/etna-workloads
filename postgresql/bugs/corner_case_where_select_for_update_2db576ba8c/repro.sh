psql -X -q -c "CREATE TABLE p (a int, b int, c int); CREATE TABLE c1 () INHERITS (p); CREATE TABLE c2 () INHERITS (p); CREATE TABLE c3 () INHERITS (p);
INSERT INTO c1 SELECT 0, a / 3, a % 3 FROM generate_series(0, 9) a;
INSERT INTO c2 SELECT 1, a / 3, a % 3 FROM generate_series(0, 9) a;
INSERT INTO c3 SELECT 2, a / 3, a % 3 FROM generate_series(0, 9) a;"
psql -X -q -c "BEGIN; UPDATE p SET b = -1 WHERE a = 1 AND b = 1 AND c = 0; SELECT pg_sleep(3); COMMIT;" >/dev/null &
sleep 1
psql -X -q -c "SELECT tableoid::regclass, ctid, * FROM p WHERE b IN (0, 1) AND c = 0 FOR UPDATE;"
wait
