create table nestjsonb (j jsonb);
insert into nestjsonb (j) values ('{"a":[["b",{"x":1}],["b",{"x":2}]],"c":3}');
insert into nestjsonb (j) values ('[[14,2,3]]');
insert into nestjsonb (j) values ('[1,[14,2,3]]');
create index on nestjsonb using gin(j jsonb_path_ops);
set enable_seqscan = off;
set enable_bitmapscan = on;
select * from nestjsonb where j @> '{"a":[[{"x":2}]]}'::jsonb;
select * from nestjsonb where j @> '[[14]]';
