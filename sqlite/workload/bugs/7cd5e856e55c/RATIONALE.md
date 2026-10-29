# Rationale

One hunk changed, in `src/select.c` `flattenSubquery()`: it reverses the fix's only implementation hunk.

The fix replaced `pParent->selFlags |= pSub->selFlags & SF_Distinct;` with `pParent->selFlags |= pSub->selFlags & SF_Compound;`, and added `assert((pSub->selFlags & SF_Distinct)==0)`. I restored the old `SF_Distinct` propagation and removed the added assert. The code around the line is unchanged since 2019, so the revert is equivalent.

Without the SF_Compound bit, a compound subquery flattened into a non-compound parent leaves the parent looking non-compound. A later flattening, such as the LIMIT subquery in the ticket, is then wrongly allowed.

## Oracle failure
`select6-12.100` fails. The debug build hits `Assertion 'p->selFlags & SF_Compound' failed` in `multiSelect`. In a non-assert build, the LIMIT would wrongly be applied to the whole union, giving the wrong result instead of `1 3`.
