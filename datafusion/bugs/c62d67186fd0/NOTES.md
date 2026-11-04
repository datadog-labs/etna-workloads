repro.sql runs `CASE WHEN v > 0 THEN v ELSE 1 / 0 END` over rows where the WHEN is true for every row (single WHEN + ELSE).
Clean: the ELSE is never evaluated, so the query returns rows. Buggy: the all-true shortcut is gone, the ELSE `1/0` is evaluated eagerly and the query fails with "Arrow error: Divide by zero error".
