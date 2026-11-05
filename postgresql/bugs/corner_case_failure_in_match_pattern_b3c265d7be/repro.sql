create temp table btree_bpchar (f1 text collate "C");
create index on btree_bpchar(f1 bpchar_ops);
insert into btree_bpchar values ('foo'), ('fool'), ('bar'), ('quux');
set enable_seqscan=off;
select * from btree_bpchar where f1 like 'foo';
select * from btree_bpchar where f1 like 'foo%';
