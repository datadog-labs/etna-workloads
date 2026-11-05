psql -X -q -c "alter system set wal_level=logical" -c "alter system set max_wal_senders=20" >/dev/null
pg_ctl -w -l /dev/null restart >/dev/null
psql -X -q <<'S'
CREATE ROLE alice LOGIN; CREATE ROLE adm2 LOGIN; GRANT pg_create_subscription TO adm2;
GRANT ALL ON SCHEMA public TO alice; GRANT CREATE ON DATABASE postgres TO alice;
CREATE DATABASE sub;
SET SESSION AUTHORIZATION alice;
CREATE TABLE t(i int); INSERT INTO t VALUES (1),(2),(3);
CREATE PUBLICATION pub FOR TABLE t;
RESET SESSION AUTHORIZATION;
SELECT 1 FROM pg_create_logical_replication_slot('sb','pgoutput');
S
psql -X -q -d sub <<'S'
GRANT CREATE ON DATABASE sub TO adm2;
GRANT ALL ON SCHEMA public TO alice;
SET SESSION AUTHORIZATION alice; CREATE TABLE public.t(i int);
S
psql -X -q -d sub <<S
ALTER ROLE adm2 SUPERUSER;
SET SESSION AUTHORIZATION adm2;
CREATE SUBSCRIPTION sb CONNECTION 'port=$PGPORT host=$PGHOST dbname=postgres' PUBLICATION pub WITH (run_as_owner=false, password_required=false, copy_data=true, enabled=false, create_slot=false, slot_name=sb);
RESET SESSION AUTHORIZATION;
ALTER ROLE adm2 NOSUPERUSER;
GRANT alice TO adm2 WITH INHERIT FALSE, SET TRUE;
ALTER SUBSCRIPTION sb ENABLE;
S
i=0
while [ $i -lt 40 ]; do
  n=$(psql -X -Atq -d sub -c "select count(*) from t" 2>/dev/null)
  [ "$n" = 3 ] && break
  i=$((i+1)); sleep 0.2
done
echo "rows copied: $n"
