# Rationale

## Change: `Objects/typeobject.c`, `PyType_GetModuleByDef`

Fix hunks reversed: both `typeobject.c` hunks. The fix changed the early
`return NULL;` for static types into `goto error`, so the TypeError is raised
for static types as well.

In v3.15.2 the logic moved: `PyType_GetModuleByDef` wraps
`PyType_GetModuleByToken_DuringGC`, and the wrapper always raises TypeError
when the result is NULL. I restored the pre-fix behaviour by adding the
static-type early `return NULL;` (with its original comment) to the wrapper
before the lookup. Static types now return NULL without setting an
exception, which is the regression from gh-133166.

## Oracle failures

`test_get_module_by_def`: `pytype_getmodulebydef(int)` returns NULL with no
exception set, so it fails (SystemError / crash instead of the expected
TypeError). The run aborts with a crash, so the other 8 cases listed by
check.sh as failing are incomplete-run fallout.
