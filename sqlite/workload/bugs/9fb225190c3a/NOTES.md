repro.sql builds a chain of 7 nested views (v1..v7 over t0), then sets
`.limit expr_depth` to 7 and 6 and selects from v7.
Clean shell: both SELECTs fail with "VIEWs and/or subqueries nested too deep" (exit 1).
Buggy shell: no depth limit on view nesting; both return 7 (exit 0).
