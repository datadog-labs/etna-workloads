psql -X -q -c "create type digit as enum ('0','1','2','3');
create table tht (en digit, data int) partition by hash (en);
create table tht_p0 partition of tht for values with (modulus 3, remainder 0);
create table tht_p1 partition of tht for values with (modulus 3, remainder 1);
create table tht_p2 partition of tht for values with (modulus 3, remainder 2);
insert into tht select (g%4)::text::digit, g from generate_series(1,20) g;"
pg_dump -t tht_p0 | grep -E '^COPY'
