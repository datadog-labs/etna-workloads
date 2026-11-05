psql -X -q -c "create table t(a int); create policy p1 on t using (true); comment on policy p1 on t is 'cmt'"
pg_dump -Fc -f "$PWD/r.dump" postgres
pg_restore --no-policies -f - "$PWD/r.dump" | grep -c 'COMMENT ON POLICY'
rm -f "$PWD/r.dump"
psql -X -q -c "drop table t"
