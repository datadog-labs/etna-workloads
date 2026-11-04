repro.sql runs sliding-window MIN/MAX (ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) over values (3, NULL, NULL, 7).
Clean: row id=3 gives NULL for min_x/max_x (frame is all NULL). Buggy build returns a stale non-NULL value there.
