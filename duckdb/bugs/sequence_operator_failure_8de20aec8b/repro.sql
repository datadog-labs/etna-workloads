.mode list
.nullvalue NULL
SET debug_verify_vector = 'dictionary_operator';
SELECT i, CASE WHEN i % 2 = 0 THEN NULL ELSE i::VARCHAR END
FROM range(4) t(i);
SET debug_verify_vector = 'constant_operator';
SELECT i, i % 2
FROM range(4) t(i);
SET debug_verify_vector = 'sequence_operator';
SELECT i::TINYINT, (i * 200)::SMALLINT, CASE WHEN i = 2 THEN NULL ELSE i END
FROM range(4) t(i);
SELECT i, i / 2, INTERVAL '1 day' * i
FROM range(4) t(i);
SELECT *
FROM (VALUES (1, 5), (1, 5), (2, 5), (4, 5)) t(irregular, constant_value);
SELECT * FROM (VALUES (1), (2), (4)) t(irregular);
SELECT *
FROM (VALUES
	((-128)::TINYINT, (-32768)::SMALLINT, (-2147483648)::INTEGER, (-9223372036854775808)::BIGINT),
	(127::TINYINT, 32767::SMALLINT, 2147483647::INTEGER, 9223372036854775807::BIGINT)
) t(tiny_value, small_value, integer_value, bigint_value);
SELECT * FROM (VALUES (1), (NULL)) t(nullable_value);
SELECT unnest([empty_struct::VARIANT, struct::VARIANT]) FROM test_all_types();
