# Rationale

File: src/backend/optimizer/prep/prepjointree.c, function pullup_replace_vars_callback (final else branch, where nullingrels are added to an expression).

Traces to the fix.patch hunk that changes `add_nulling_relids(newnode, NULL, ...)` to `add_nulling_relids(newnode, rcon->relids, ...)`. Later code evolved to also add per-lateral-rel nullingrels. I removed that lateral-specific block and went back to `add_nulling_relids(newnode, NULL, var->varnullingrels)`. This marks every Var/PHV in the expression, including lateral references to rels outside the subquery. Those references get nullingrels they should not have, so they are mislabeled.

Failing oracle case: src/test/regress||subselect
