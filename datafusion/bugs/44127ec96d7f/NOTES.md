repro.sql copies the lead/lag NULL-input statements added to window.slt by the fix.
Clean build: `LEAD/LAG(NULL, n, false) OVER ()` returns NULL/false as expected.
Buggy build: each of those queries fails with "Arrow error: Cast error: Casting from Boolean to Null not supported".
