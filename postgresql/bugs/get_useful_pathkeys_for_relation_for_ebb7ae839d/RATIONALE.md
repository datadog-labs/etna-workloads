# Rationale

File: src/backend/optimizer/path/equivclass.c, function relation_can_be_sorted_early()
(the modern replacement of find_em_expr_usable_for_sorting_rel, which get_useful_pathkeys_for_relation
in allpaths.c now calls). Traces to the fix.patch hunk adding find_em_expr_usable_for_sorting_rel
and switching get_useful_pathkeys_for_relation to it.

Changes:
1. Removed the early "reject volatile ECs" return (the fix's `ec_has_volatile` handling, which
   only allows a volatile member if it is already in the rel's target).
2. For volatile ECs, parallel-safety is no longer required, so a volatile member such as
   `stringu1 || random()::text` computable from the rel's Vars is considered sortable early.

Effect: the parallel sort gets pushed below Gather Merge on volatile expressions that must only be
evaluated in the upper rel (the bug fixed upstream).

Failing oracle case: src/test/regress||incremental_sort
(select_distinct is also affected by the change.)
