# Rationale

Fix (gh-109118) made LOAD_FROM_DICT_OR_GLOBALS release `mod_or_class_dict`
only at the end (DECREF_INPUTS), leaving it on the stack on error paths so the
unwinder owns the single reference. The pre-fix code decref'd it early and
then took `goto error` with the dict still on the stack: a double decref.

## Changed: `Python/bytecodes.c`, LOAD_FROM_DICT_OR_GLOBALS
(plus regenerated `Python/generated_cases.c.h` and `Python/executor_cases.c.h`)
- Reverses the hunk that removed the early `Py_DECREF(mod_or_class_dict)` in
  the error paths and moved the decref to the end. The input is again
  released right after the lookup (`Py_DECREF(namespace)`), the error exits
  (`err < 0`, global/builtin lookup failure -> NameError) use `ERROR_NO_POP()`
  with the dict still on the stack, and `DEAD(mod_or_class_dict)` at the end
  tells the generator the input was consumed.
- The v3.15.2 form uses PyStackRef_CLOSE plus ERROR_IF, which pops first, so
  the equivalent bug has to be written with a raw decref and ERROR_NO_POP.
- LOAD_NAME no longer exists in macro form (it calls `_PyEval_LoadName`), so
  it needed no change.

## Oracle
`test_type_params` crashes the interpreter (incomplete run). That includes
`TypeParamsRuntimeTest.test_name_error` and `test_broken_class_namespace`,
the tests the fix added, plus other type-param tests that run after the crash.
