psql -X -q -c "CREATE TABLE ot (id int primary key, data int);
CREATE FUNCTION of() RETURNS SETOF ot LANGUAGE sql BEGIN ATOMIC SELECT * FROM ot GROUP BY id; END;"
pg_dump -s | grep -E '^(ALTER TABLE ONLY public.ot|CREATE FUNCTION public.of)' 
psql -X -q -c "DROP FUNCTION of(); DROP TABLE ot;"
