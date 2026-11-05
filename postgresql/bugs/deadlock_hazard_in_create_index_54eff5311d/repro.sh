psql -X -q -c "CREATE TABLE mcic_one(id int); CREATE TABLE mcic_two(id int);
CREATE FUNCTION lck_shr(bigint) RETURNS bool IMMUTABLE LANGUAGE plpgsql AS \$\$ BEGIN PERFORM pg_advisory_lock_shared(\$1); RETURN true; END; \$\$;
CREATE FUNCTION unlck() RETURNS bool IMMUTABLE LANGUAGE plpgsql AS \$\$ BEGIN PERFORM pg_advisory_unlock_all(); RETURN true; END; \$\$;"
( echo "SELECT pg_advisory_lock(281457);"; sleep 3; echo "CREATE INDEX CONCURRENTLY mcic_two_pkey ON mcic_two (id) WHERE unlck();"; sleep 3 ) | psql -X -q > /dev/null 2>&1 &
sleep 1
timeout 20 psql -X -q -c "CREATE INDEX CONCURRENTLY mcic_one_pkey ON mcic_one (id) WHERE lck_shr(281457);" 2>&1 | head -3
wait
psql -X -q -c "select 'done'" 2>&1 | head -3
