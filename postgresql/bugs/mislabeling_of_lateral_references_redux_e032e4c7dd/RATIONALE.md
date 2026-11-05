# Rationale

Hunk: src/backend/optimizer/prep/prepjointree.c, `pullup_replace_vars_callback()`.
Traces to the fix_impl.patch hunk that adds the `if (rcon->target_rte->lateral)` block
(using `pull_varnos`, `nullinfo->nullingrels[lvarno]`, `add_nulling_relids`) in the
"modify Vars/PHVs" branch.

I removed that block. Lateral references inside a pulled-up expression no longer get only
the nullingrels that apply to them. Only the subquery's own Vars get `var->varnullingrels`
added. Lateral refs are therefore mislabeled, which is the original bug. The
`nullinfo` field and `get_nullingrels()` stay as unused leftovers.

Failing oracle case: src/test/regress||subselect (expected; see the oracle output).
