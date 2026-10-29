`repro.sql` runs window1-52.4: a window with `PARTITION BY 6 COLLATE binary` and a RANGE frame,
alongside another window with a different ORDER BY.

Clean: `1|356|356|4 / 2|399|399|2 / 3|158|158|2 / 4|938|938|4`.
Buggy: the first two rows give `514|158` and `913|158`. The constant in PARTITION BY is wrapped
in a COLLATE node and isn't turned into NULL, so the partitions come out wrong.
