# Re-introduced bug: loose Set/Map comparison fast path (fix be5e3964b316)

**Bug.** In loose deep equality, the primitive fast path for Sets/Maps assumed each primitive has only a few
canonical loose-equal counterparts (e.g. `1` <-> `'1'`/`true`). Other spellings (`1n == '+0001'`, `'-000' == 0`,
`'2' == 2n`) were missed, so loose-equal Sets/Maps compared as unequal.

**Changes (all in lib/internal/util/comparisons.js)**
- `findLooseMatchingPrimitives` restored to the old version returning an explicit list of canonical alternative
  values (fix hunk removing the old function / adding the new "might have" one, reversed).
- Added back `setHasLoosePrim` and `mapHasLoosePrim` (the removed helpers; replacing `setMightHaveLoosePrim` /
  `mapMightHaveLoosePrim`). Map version compares item lists with `innerDeepEqual` (kLoose) as today's code requires.
- `setEquiv`: fast path uses `setHasLoosePrim`, and a primitive that passes is skipped rather than queued for a full
  comparison (fix hunk in setEquiv, reversed).
- `mapEquiv`: loose miss now returns false unless `mapHasLoosePrim` matches; no longer queues key for full comparison.

**Failing test.** `parallel/test-assert-deep` fails (`not ok 1`), because the new loose Map/Set cases
(`new Map([[undefined, null], ['+000', 2n]])` vs `new Map([[null, undefined], [false, '2']])`, and the Set with `1n, 5, 2n, false` vs `5n, true, '2', '-000'`) are no longer deemed loosely equal.
