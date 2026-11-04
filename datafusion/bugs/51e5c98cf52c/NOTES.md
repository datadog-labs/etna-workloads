repro.sql calls nanvl with a NULL second argument. The scalar case is `nanvl(1.0, NULL)`. The array case is a VALUES table row (1.0, NULL).
Clean build returns x (1.0) because x is not NaN. Buggy build returns NULL in both cases, and the array case also reorders rows.
