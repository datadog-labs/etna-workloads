# Rationale

Reverted fix: dummy Append paths must carry rel->lateral_relids as required_outer.

- src/backend/optimizer/path/allpaths.c, set_dummy_rel_pathlist(): create_append_path's required_outer argument changed from `rel->lateral_relids` back to `NULL` (traces to the allpaths.c hunk of fix_impl.patch). A dummy path for a parameterized (lateral) rel is then wrongly unparameterized.
- src/backend/optimizer/path/joinrels.c, mark_dummy_rel(): same change (traces to the joinrels.c hunk).

Failing oracle case: src/test/regress||join
