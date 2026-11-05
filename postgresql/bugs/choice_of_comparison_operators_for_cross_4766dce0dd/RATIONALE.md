# Rationale

File: src/backend/executor/nodeSubplan.c, function ExecInitSubPlan (hashed subplan setup).

Traces to the fix.patch hunks that introduced `cross_eq_funcoids`:
- The cross-type equality function OID (`opexpr->opfuncid`) is stored in `sstate->tab_eq_funcoids` again, instead of a local array.
- The RHS-type equality OID, `get_opcode(rhs_eq_oper)`, is no longer stored in `tab_eq_funcoids`.
- `ExecBuildGroupingEqual` for `cur_eq_comp` is passed `sstate->tab_eq_funcoids` again.

Effect: `tab_eq_funcoids` holds the cross-type operator functions. The hash table code also uses it, and it needs same-type RHS comparisons. Cross-type hashed subplans therefore pick the wrong comparison operators.

The `cross_eq_funcoids` declaration and palloc remain as unused leftovers.

Failing oracle case: src/test/regress||subselect
