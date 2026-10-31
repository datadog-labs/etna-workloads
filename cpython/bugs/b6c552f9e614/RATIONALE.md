# Rationale

## Objects/typeobject.c, `set_tp_bases`
Reverses the fix hunk that relaxed `assert(PyTuple_CheckExact(bases))` to
`assert(PyTuple_Check(bases))` and moved the exact check into the static-builtin
branch. In v3.15.2 the relaxed assert and the inner exact assert are both present
(plus `ASSERT_NEW_TYPE_OR_LOCKED`); I restored the pre-fix form: an exact-tuple
assert at the top of the function, and removed the inner duplicate (it is
implied). Tuple subclasses passed as `bases` to `type()` again abort in a debug build.

## Oracle failures
`ClassCreationTests.test_tuple_subclass_as_bases` fails: `type("typ", TupleSubclass((int, object)), {})`
hits the assertion and aborts the interpreter. Because the abort kills the test
process, the remaining test_types cases after it are reported as failing too (incomplete run).
