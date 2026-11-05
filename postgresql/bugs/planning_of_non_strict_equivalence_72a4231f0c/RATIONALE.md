# Rationale

The 2012 fix (check_equivalence_delay / em_nullable_relids) targets machinery
that no longer exists: outerjoin_delayed and nullable_relids were replaced by
varnullingrels and JoinDomains. The modern code protects the same invariant,
that equivalences must not be derived across an outer join for a nullable-side
value, with JoinDomains. EC members that are constants only match within the
same join domain.

## Changed hunk
- File/function: src/backend/optimizer/path/equivclass.c, `process_equivalence`.
- Traces to: the fix.patch hunks in `process_equivalence` and
  `distribute_qual_to_rels` (the per-side outer-join safety check for
  potential equivalence clauses).
- Change: removed the `em_is_const && em_jdomain != jdomain` skip while
  searching for existing EC members.
- Why it brings the bug back: a clause such as `coalesce(b.x,0) = 0`, which is
  non-strict and sits above an outer join, can now merge with a constant EC
  from a different join domain. Derived clauses can then be pushed below the
  outer join and use the wrong value for the nullable variable.

I did not re-add any em_nullable_relids bookkeeping, because that field
doesn't exist in the current code.

## Failing oracle cases
- src/test/regress||join
