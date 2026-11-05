# Rationale
Reintroduces have_dangerous_phv() join-order restriction.

- src/include/optimizer/paths.h: re-declare have_dangerous_phv (paths.h hunk of fix).
- joinrels.c: re-add have_dangerous_phv() function (removal hunk) before is_dummy_rel(); re-add the two checks in join_is_legal() (lateral_fwd / lateral_rev branches).
- joinpath.c try_nestloop_path(): re-add `have_dangerous_phv` rejection of parameterized nestloops.

The createplan.c/paramassign.c hunks (which make the planner able to handle such PHVs) are already present in today's code; the restriction forbids plans that now work, so the join regression test shows different plans.

Failing oracle case: src/test/regress||join
