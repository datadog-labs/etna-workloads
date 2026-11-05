# Rationale

Both hunks are in src/backend/tsearch/spell.c and trace to fix_impl.patch.

1. `getAffixFlagSet()`: this traces to the hunk that changed `curaffix <= nAffixData` to `<` and added an `else if (curaffix > nAffixData) ereport(ERROR ...)`. I restored `<=` and removed the error branch. An out-of-range affix alias is now accepted, and the index `nAffixData` is read from `AffixData` out of bounds. Larger aliases silently become VoidString.
2. `NISortDictionary()`: this traces to the hunk that added two checks. One rejects `curaffix < 0 || curaffix >= nAffixData`. The other rejects trailing garbage after the number. I removed both. A bad alias in a .dict file is then stored as `p.d.affix`, and `makeCompoundFlags` and `MergeAffix` index `AffixData` out of bounds.

I did not restore the `Assert` hunks (`IsAffixFlagInUse`, `MergeAffix`, `makeCompoundFlags`). They only matter in assert-enabled builds and don't change behaviour.

Oracle case expected to fail: src/test/regress||tsdicts
