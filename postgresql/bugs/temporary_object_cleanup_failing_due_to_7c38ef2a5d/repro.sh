psql -X -q -At <<'SQL'
CREATE FUNCTION exec(text) RETURNS text LANGUAGE plpgsql AS $$BEGIN EXECUTE $1; RETURN 'x'; END$$;
SQL
psql -X -q -At >/dev/null <<'SQL'
SELECT exec(format($o$CREATE FUNCTION pg_temp.long() RETURNS text LANGUAGE sql AS $b$ SELECT %L; $b$$o$,
 (SELECT string_agg(g.i::text||':'||md5(g.i::text), '|') FROM generate_series(1,100) g(i))));
CREATE TEMPORARY TABLE invalidate_catalog_cache();
CREATE TEMPORARY TABLE just_give_me_a_type(id serial primary key);
CREATE FUNCTION uses_a_temp_type(just_give_me_a_type) RETURNS int LANGUAGE sql AS $$SELECT 1;$$;
SQL
sleep 3
psql -X -q -At -c "SELECT count(*) FROM pg_proc WHERE proname in ('long','uses_a_temp_type')"
