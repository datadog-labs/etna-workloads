psql -X -q -c "LISTEN c1" -c "select 1" >/dev/null
( echo "LISTEN c1;"; echo "BEGIN;"; sleep 4; echo "COMMIT;" ) | psql -X -q >/dev/null 2>&1 &
sleep 1
psql -X -q -c "NOTIFY c1"
psql -X -q <<'SQL'
BEGIN ISOLATION LEVEL SERIALIZABLE;
LISTEN c1;
LISTEN c2;
COMMIT;
SELECT 'done' AS result;
SQL
wait
