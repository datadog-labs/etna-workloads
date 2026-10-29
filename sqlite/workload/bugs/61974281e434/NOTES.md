repro.sql: GROUP BY query on a TEXT column used as `x=y` in an EXISTS subquery
against an indexed INT column. The buggy shell applies INT affinity to the
register holding y, so the last typeof(y) returns `integer` instead of `text`.
Clean: `text|0|text`.
