SELECT * FROM generate_series(1, 5) WHERE value = (value & 14) LIMIT 3;
