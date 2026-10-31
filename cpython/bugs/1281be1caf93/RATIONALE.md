# Rationale

## Python/specialize.c, `specialize_method_descriptor`
Reverses the fix hunk that added `if (PyList_CheckExact(self_or_null))` around
`specialize(instr, CALL_LIST_APPEND)`. `list.append` on any receiver (including
list subclasses) is again specialized to CALL_LIST_APPEND.

The fix's other hunks removed `PyList_CheckExact` from the `_CALL_LIST_APPEND`
body. In v3.15.2 that check is now covered by the separate `_GUARD_NOS_LIST`
uop, so it is not reverted. The specializer is the only place the defect
shows up: the instruction is chosen for subclasses and then deopts
on the guard instead of using CALL_METHOD_DESCRIPTOR_O. The signature change
to pass `self_or_null` is left in place (it is now unused beyond an assert-free parameter).

## Oracle
`test.test_opcache.TestSpecializer.test_call_list_append` fails: for a `list`
subclass, `CALL_METHOD_DESCRIPTOR_O` is not found and `CALL_LIST_APPEND` is
present.
