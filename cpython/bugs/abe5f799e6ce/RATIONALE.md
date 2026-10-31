# Rationale

Fix: `typealias_alloc` normalised `type_params` of `()` to NULL, so
`TypeAliasType("TA", ..., type_params=())` was not generic.

In v3.15.2 the normalisation moved: `typealias_new_impl` calls
`typealias_check_type_params`, which returned NULL for a 0-length tuple
(`if (!length) return NULL;`). (The `type` statement path uses
`typealias_convert_type_params`, left untouched.)

Change (Objects/typevarobject.c): removed the 0-length-tuple early return in
`typealias_check_type_params`. The empty tuple is now stored as-is in
`ta->type_params`, which is the pre-fix behaviour (`Py_XNewRef(type_params)`
with no empty-tuple check), so the alias is treated as generic.

Failing oracle case: `TypeAliasConstructorTest.test_not_generic`
(`TA[int]` does not raise "Only generic type aliases are subscriptable").
