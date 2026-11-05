# Rationale
File: src/backend/utils/adt/like_support.c, function match_pattern_prefix().

Traces to the three fix.patch hunks that replaced `elog(ERROR, "no ... operator for opfamily")` with quiet returns. The current code checks `op_in_opfamily(eqopr/geopr/ltopr, opfamily)` instead of calling get_opfamily_member. I restored the errors on those checks:
- `=` check: `return NIL` -> `elog(ERROR, "no = operator for opfamily %u")`
- `>=` check: `return NIL` -> `elog(ERROR, "no >= operator ...")`
- `<` check: `return result` -> `elog(ERROR, "no < operator ...")`

With binary-compatible opclasses lacking a suitable operator, the planner now errors instead of declining to use the index.

Failing oracle case: src/test/regress||btree_index
