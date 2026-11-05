# Rationale

## src/backend/optimizer/plan/setrefs.c, add_rtes_to_flat_rtable()
Traces to the createplan.c create_append_plan hunk in fix.patch, which wrapped a
dummy (constraint-excluded) subquery's plan in a SubqueryScan so setrefs.c would pull
up the subquery's rangetable and the executor would check permissions on its rels.
In current code that job is done in setrefs.c: for a planned subquery whose final rel
is dummy, its RTEs are pulled up by recursing. I removed the `IS_DUMMY_REL(...)`
condition, leaving only `recursing`. A subquery proven empty then contributes no RTEs
to the final rangetable, so permission checks on its tables/views are skipped.

## Failing oracle cases
- src/test/regress||privileges
(src/test/regress||matview still passes)
