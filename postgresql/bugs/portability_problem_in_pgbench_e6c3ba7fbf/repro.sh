psql -X -q -c "drop table if exists r; create table r(x bigint)"
cat > r.pgb <<'EOP'
\set x random_gaussian(1, 1000000000, 2.5)
insert into r values (:x);
EOP
pgbench -n -f r.pgb -t 3 -c 1 --random-seed=5 postgres >/dev/null 2>&1
psql -X -At -c "select x from r"
