psql -X -q -c "CREATE TABLE tab_s (a int)"
psql -X -q --single-transaction -v ON_ERROR_STOP=1 -c "INSERT INTO tab_s VALUES (3)" -c "\\copy tab_s FROM 'nonexistent_file'" 2>&1 | sed 's/^.*nonexistent_file.*$/copy error/'
psql -X -q -c "SELECT count(*) FROM tab_s"
