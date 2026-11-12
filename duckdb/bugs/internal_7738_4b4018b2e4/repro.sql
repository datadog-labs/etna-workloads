.mode list
.nullvalue NULL
SET prefer_range_joins=false;
SET merge_join_threshold=0;
SET nested_loop_join_threshold=0;
CREATE TABLE left_small(
	id INTEGER,
	start DATE,
	stop DATE,
	symbol VARCHAR,
	price DECIMAL
);
INSERT INTO left_small VALUES
    (1, '2026-01-01', '2026-01-02', 'A', 150.00),
    (2, '2026-01-02', '2026-01-03', 'A', 151.00),
    (3, '2026-01-03', '2026-01-04', 'B', 380.00);
CREATE TABLE right_small (
	id INTEGER,
	start DATE,
	stop DATE,
	symbol VARCHAR,
	bid DECIMAL,
	active BOOLEAN
);
INSERT INTO right_small VALUES
    (1, '2026-01-01', '2026-01-03', 'A', 149.50, true),
    (2, '2026-01-03', '2026-01-04', 'A', 150.50, false),
    (3, '2026-01-04', '2026-01-05', 'B', 379.00, true);
SELECT l.id, l.start, l.stop
FROM left_small l
SEMI JOIN right_small r
       ON l.start < r.stop
      AND r.start < l.stop
      AND l.symbol = r.symbol
      AND l.price + r.bid > 300
ORDER BY 1;
