.mode list
.nullvalue NULL
SET threads=1;
PRAGMA enable_verification;
SELECT count(*)
FROM (VALUES (0, 10, 1.5), (1, 11, 1.5), (2, 12, 1.5), (3, 13, 1.5),
             (4, 14, 1.5), (5, 15, 1.5), (6, 16, 1.5), (7, 17, 1.5)) l(start, stop, price)
ANTI JOIN (SELECT i AS start, i + 1 AS stop, 150.0 + i AS bid FROM range(100) t(i)) r
  ON l.start < r.stop AND r.start < l.stop AND l.price + r.bid < 400;
