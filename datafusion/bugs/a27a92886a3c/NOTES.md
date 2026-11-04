Reproducer: `select *, <expr> from t` (wildcard plus another column) with an ORDER BY.

With the bug, the wildcard is dropped from the select list, so the buggy build returns only the extra column (`ta` or `b`) and omits `a`. The clean build returns `a` as well.
