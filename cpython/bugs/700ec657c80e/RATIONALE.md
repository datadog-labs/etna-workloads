# Rationale

Fix (gh-103596) made `enum.property.__get__` fall back to a previously defined
mixin attribute (`_attr_type == 'attr'`) or descriptor (`'desc'`) instead of
returning the member, so members don't shadow mixed-in methods/attributes.

In v3.15.2 this logic is in `Lib/enum.py`, `property.__get__`. I removed the
two `elif self._attr_type == 'attr'` / `'desc'` branches, restoring the pre-fix
behaviour: with no `fget`, access through an instance always returns the member
from `_member_map_`. (The `_add_member_` bookkeeping that sets `_attr_type` /
`_cls_type` is left in place; it is now unused, as before the fix it did not exist.)

Oracle failures: `test_shadowed_attr` in TestIntEnum / TestStrEnum (and the
Function variants), e.g. `Number.divisor.numerator` returns
`<Number.numerator: 2>` instead of `1`; `Book.author.title()` fails as the
member is not callable.
