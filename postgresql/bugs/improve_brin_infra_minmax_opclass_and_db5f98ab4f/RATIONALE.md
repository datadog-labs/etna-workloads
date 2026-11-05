# Rationale

Hunk: src/backend/access/brin/brin_minmax.c, brin_minmax_consistent().
Traces to the fix.patch hunk that adds `subtype = key->sk_subtype;` and passes it to
minmax_get_strategy_procinfo (replacing the same-type-only PROCNUM lookups).
The change uses the indexed column's own type (attr->atttypid) as the subtype instead of the
scan key's sk_subtype. Cross-type scan keys (e.g. int8/date/timestamp column vs different-type
constant) then look up a same-type operator, so the comparison is done with the wrong operator
or errors with "missing operator", which is the cross-type handling the fix added.

Failing oracle case: src/test/regress||brin (expected; see oracle output)
