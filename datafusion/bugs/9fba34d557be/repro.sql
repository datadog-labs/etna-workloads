select unnest(column1) from (select * from (values([1,2,3]), ([4,5,6])) limit 1 offset 1);
