# Rationale

Fix hunk (Objects/rangeobject.c, `longrangeiter_setstate`) added a
`PyLong_CheckExact(state)` guard raising `TypeError`. In v3.15.2 the function
is `longrange_iterator___setstate___impl`; I removed the same guard from the
top of that function. Nothing else changed, so non-int states (e.g. `1.0`)
again reach the arithmetic and produce a non-int `start`, which is the
original assertion-failure bug.

Oracle failure: `test_iterator_invalid_setstate` (subtest
`invalid_value=1.0, range='longrangeiter'`) fails with "TypeError not raised".
