# Rationale

File: src/backend/utils/adt/ruleutils.c, function get_simple_values_rte().

Traces to the fix_impl.patch hunk that computes the column name get_target_list() would use. That name comes from resultDesc when one is given, and otherwise from tle->resname. The patched code compares it with the VALUES RTE's colnames.

The change makes the comparison use only tle->resname and ignore resultDesc. When resultDesc forces column names that differ from the VALUES RTE's names, the view is still deparsed as a bare VALUES(...). The forced column aliases are lost.

Failing oracle case: src/test/regress||rules
