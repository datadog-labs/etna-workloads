.mode list
.nullvalue NULL
CREATE TABLE row_number_order (id INTEGER, g INTEGER, p INTEGER);
INSERT INTO row_number_order VALUES (1, 1, 1), (2, 1, 2), (3, 1, 3), (4, 2, 1), (5, 2, 2);
SELECT id, g, p
FROM row_number_order
QUALIFY ROW_NUMBER(ORDER BY id DESC) OVER (
	PARTITION BY g
	ORDER BY p ASC
	ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
) <= 1
ORDER BY g, id;
