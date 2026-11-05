# Rationale

File: src/backend/optimizer/path/equivclass.c, function generate_join_implied_equalities_broken.

Traces to the fix.patch hunk in generate_join_implied_equalities_broken. That hunk replaced a single-level
adjust_appendrel_attrs (using the inner child's immediate AppendRelInfo) with
adjust_appendrel_attrs_multilevel, so that nested appendrel children get all levels of Var translation.
In current code the multilevel call is replaced again with a single-level adjust_appendrel_attrs using only the
inner rel's own AppendRelInfo. For a grandchild inner rel, the ec_sources clauses (which reference the top
baserel) are only translated to the intermediate parent's Vars, giving wrong or failing plans.

Failing oracle case: src/test/regress||equivclass
