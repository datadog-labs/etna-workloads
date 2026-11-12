.mode list
.nullvalue NULL
SET threads=1;
SELECT julian(c1) 
FROM test_vector_types(CAST(NULL AS DATE)) AS test_vector_types(c1);
create table all_types as 
	select * exclude(small_enum, medium_enum, large_enum) 
	from test_all_types();
SELECT julian(CAST(ref_0.date AS DATE)) AS c1 
FROM main.all_types AS ref_0;
