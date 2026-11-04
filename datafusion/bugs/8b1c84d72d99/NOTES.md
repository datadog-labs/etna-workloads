Reproducer for the named-window identifier normalization bug. `repro.sql` runs two window queries. One defines `w` and references `OVER W`. The other defines `W` and references `OVER w`.
Clean build: both queries return the rows (1,2),(2,4),(3,7),(4,11),(5,16).
Buggy build: the window name is compared without normalization, so the queries fail with "The window ... is not defined!".
