CREATE TABLE parted (a text, b int) PARTITION BY LIST (a);
CREATE TABLE part_b PARTITION OF parted (
	b NOT NULL,
	b DEFAULT 1,
	b CHECK (b >= 0)
) FOR VALUES IN ('b');
SELECT conname FROM pg_constraint WHERE conrelid = 'part_b'::regclass ORDER BY 1;
