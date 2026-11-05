# Rationale

Hunk: src/backend/parser/parse_relation.c, `scanNSItemForColumn`.
Traces to fix.patch hunk "scanNSItemForColumn ... pass the wrong RTE to markVarForSelectPriv".
The fix makes marking use the Var's own RTE (var->varno, the base table). The current code
already does that via markVarForSelectPriv(pstate, var). I reverted to marking the nsitem's
own RTE (nsitem->p_rtindex) via markRTEForSelectPriv. For a join nsitem that is the join RTE,
so ordinary columns are not recorded in the base table's selectedCols. Column-level SELECT
privileges are then understated for columns referenced through join aliases (CVE-2021-20229).

Oracle case expected to fail: src/test/regress||privileges
