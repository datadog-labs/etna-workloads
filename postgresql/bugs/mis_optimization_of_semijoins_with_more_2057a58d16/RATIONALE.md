# Rationale
- src/backend/optimizer/path/joinpath.c, add_paths_to_joinrel(): case JOIN_UNIQUE_INNER sets
  `extra.inner_unique = true` unconditionally instead of checking that outerrel covers sjinfo->min_lefthand
  (fix_impl.patch hunk 2). With only part of the LHS, the unique-ified inner is not unique relative to the LHS,
  so the executor may skip rows wrongly (mis-optimization).

Failing oracle case: src/test/regress||join
