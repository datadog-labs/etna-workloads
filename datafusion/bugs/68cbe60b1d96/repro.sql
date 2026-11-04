SELECT map(['a','b'], [column1, column1 * 10]) FROM (VALUES (1), (2), (3)) t;
SELECT map([column1, column1 * 10], ['x','y']) FROM (VALUES (1), (2), (3)) t;
