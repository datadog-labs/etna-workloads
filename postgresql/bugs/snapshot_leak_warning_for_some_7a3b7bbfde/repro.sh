psql -X -a -q <<'SQL' 2>&1 | sed 's/0x[0-9a-f]*/PTR/'
CREATE PROCEDURE t10a(INOUT x int) LANGUAGE plpgsql AS $$
BEGIN x := x + 1; COMMIT; END; $$;
CALL t10a(10);
SQL
