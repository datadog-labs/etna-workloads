SET variant_minimum_shredding_size = 0;
create table tbl(col variant);
SET force_variant_shredding = 'STRUCT(a STRUCT(b VARCHAR, c VARCHAR))';
insert into tbl select {'a': {'b': 'hello', 'c': 'world'}} from range(5);
checkpoint;
select s.fully_shredded.stats.min, s.fully_shredded.stats.max from (select stats(col.a.b) s from tbl limit 1);
