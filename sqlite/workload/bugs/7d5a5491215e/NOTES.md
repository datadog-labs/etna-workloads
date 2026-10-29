repro.sql: runs update-21.4. UPDATE with a subquery in WHERE (OR'd with `c5 is null`) was wrongly
allowed to use one-pass multi-row mode, so the subquery `min(vkey)` sees rows already updated.
Clean: `6|-54` and `100|`. Buggy: `100|` and `100|-54` (extra row updated).
