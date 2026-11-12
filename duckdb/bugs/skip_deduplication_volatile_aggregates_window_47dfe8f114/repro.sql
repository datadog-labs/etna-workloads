SELECT count(*) FROM (
	SELECT
		any_value(uuid()::varchar) OVER (PARTITION BY g) AS id_a,
		any_value(uuid()::varchar) OVER (PARTITION BY g) AS id_b
	FROM (VALUES (1),(1),(2),(2)) t(g)
) WHERE id_a = id_b;
