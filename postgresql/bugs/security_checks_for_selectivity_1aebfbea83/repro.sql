CREATE ROLE rl_alice;
GRANT CREATE ON SCHEMA public TO rl_alice;
CREATE TABLE rls_tbl (a int);
INSERT INTO rls_tbl SELECT x/10 FROM generate_series(1, 100) x;
CREATE TABLE rls_child_tbl () INHERITS (rls_tbl);
INSERT INTO rls_child_tbl SELECT x/10 FROM generate_series(1, 100) x;
ANALYZE rls_tbl, rls_child_tbl;
ALTER TABLE rls_tbl ENABLE ROW LEVEL SECURITY;
CREATE POLICY p1 ON rls_tbl USING (a < 0);
GRANT SELECT ON rls_tbl TO rl_alice;
SET SESSION AUTHORIZATION rl_alice;
CREATE FUNCTION op_leak(int, int) RETURNS bool
    AS 'BEGIN RAISE NOTICE ''op_leak => %, %'', $1, $2; RETURN $1 < $2; END'
    LANGUAGE plpgsql;
CREATE OPERATOR <<< (procedure = op_leak, leftarg = int, rightarg = int,
                     restrict = scalarltsel);
SELECT * FROM rls_tbl WHERE a <<< 1000;
