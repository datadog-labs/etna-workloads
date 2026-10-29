repro.sql: count(DISTINCT x) on a 3-row table. The injection makes the distinct
check use the wrong register (regAgg+1), so results differ (expected `1|2|3|3`).
