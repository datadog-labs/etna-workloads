# Rationale

File: src/backend/utils/adt/ruleutils.c, function get_simple_values_rte().
Traces to the fix.patch hunk that adds the targetlist/column-name comparison after the rtable scan. In today's code that check also accounts for resultDesc. I removed the whole `if (result) {...}` block, so the function returns the VALUES RTE without comparing names.

Effect: a view defined as `CREATE VIEW v(a,b) AS VALUES (...)` has column aliases injected into its tlist. It is deparsed as a bare `VALUES ...`, so the aliases are lost.

Failing oracle case (confirmed: FAIL): src/test/regress||rules
