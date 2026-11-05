# Rationale

Single file changed: src/backend/optimizer/plan/initsplan.c. Reverses fix_impl.patch,
re-adapted to current code (which has the extra `incompatible_relids` argument).

- `JoinTreeItem` struct: removed `jti_parent` and `lateral_clauses`; re-added the `PostponedQual` struct
  (fix.patch hunk 1).
- `deconstruct_jointree`, `deconstruct_recurse`: restored the local `postponed_qual_list` and passing of it
  to `deconstruct_distribute`; dropped the `parent_jtitem` argument (hunks on those functions).
- `deconstruct_distribute`: FromExpr/JoinExpr nodes again scan the global postponed_qual_list and take
  any qual whose relids are within their qualscope, instead of using per-item `lateral_clauses`.
- `distribute_quals_to_rels` / `distribute_qual_to_rels` / `process_security_barrier_quals` /
  `deconstruct_distribute_oj_quals`: signatures take JoinDomain + postponed_qual_list again; a qual
  with out-of-scope (lateral) references is appended to the global postponed list rather than to the
  nearest ancestor jointree item that covers its relids (no more "failed to postpone" error path).

This brings back the old postponed-qual handling, which misplaces lateral-referencing quals in some
join trees.

Failing oracle case: src/test/regress||join
