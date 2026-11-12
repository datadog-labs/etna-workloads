.mode list
.nullvalue NULL
PRAGMA enable_optimizer;
SELECT list_transform(
	list_filter(list_transform(l, lambda x: struct_pack(filter := true, result := x)), lambda s: s.filter),
	lambda s: s.result::BOOLEAN::INTEGER
) FROM (VALUES ([2])) t(l);
SELECT list_transform(
	list_filter(list_transform(l, lambda x: struct_pack(filter := true, result := x)), lambda s: s.filter),
	lambda s: s.result::VARCHAR
) FROM (VALUES ([2])) t(l);
SELECT list_transform(
	list_filter(list_transform(l, lambda x: struct_pack(filter := x, result := x)),
	            lambda s: s.filter::DECIMAL(1,0)::BOOLEAN),
	lambda s: s.result
) FROM (VALUES ([0.1,0.9])) t(l);
SELECT list_transform(
	list_filter(list_transform(l, lambda x: struct_pack(filter := x, result := x)),
	            lambda s: TRY_CAST(s.filter AS BOOLEAN)),
	lambda s: s.result
) FROM (VALUES (['true','bad'])) t(l);
SELECT list_transform(
	list_filter(list_transform(l, lambda x: struct_pack(filter := true, result := x)
	            ::STRUCT(filter BOOLEAN,result BOOLEAN)::STRUCT(filter BOOLEAN,result INTEGER)), lambda s: s.filter),
	lambda s: s.result
) FROM (VALUES ([2])) t(l);
SELECT list_transform(
	list_filter(list_transform(l, lambda x: struct_pack(filter := true, result := x)), lambda s: s.filter),
	lambda s: (s::STRUCT(filter BOOLEAN,result BOOLEAN)::STRUCT(filter BOOLEAN,result INTEGER)).result
) FROM (VALUES ([2])) t(l);
SELECT list_transform(
	list_filter(list_transform(l, lambda x: struct_pack(filter := true, result := x)), lambda s: s.filter),
	lambda s: s.result::BOOLEAN::INTEGER
) FROM (VALUES (1, [0,2,NULL,-3]), (2, []), (3, NULL)) t(id,l) ORDER BY id;
SELECT count(*) FROM (
	SELECT list_transform(
		list_filter(list_transform([i + 2], lambda x: struct_pack(filter := true, result := x)), lambda s: s.filter),
		lambda s: s.result::BOOLEAN::BIGINT
	) AS l FROM range(6145) t(i)
) t WHERE l = [1];
PREPARE list_cast AS SELECT list_transform(
	list_filter(list_transform(l, lambda x: struct_pack(filter := true, result := x)), lambda s: s.filter),
	lambda s: s.result::BOOLEAN::INTEGER
) FROM (VALUES ($1)) t(l);
EXECUTE list_cast([2]);
DEALLOCATE list_cast;
PRAGMA disable_optimizer;
SELECT list_transform(
	list_filter(list_transform(l, lambda x: struct_pack(filter := true, result := x)), lambda s: s.filter),
	lambda s: s.result::BOOLEAN::INTEGER
) FROM (VALUES ([2])) t(l);
