# Rationale

File: src/backend/utils/adt/regproc.c, functions `regrolein` and `regnamespacein`.
These trace to the fix.patch hunks that made regrolein/regnamespacein (and so
to_regrole/to_regnamespace) parse their input with `stringToQualifiedNameList`.
In current code to_regrole and to_regnamespace call regrolein and regnamespacein
through `DirectInputFunctionCallSafe`, so the two input functions are the only
places that needed changing.

The fix parsed the input with `stringToQualifiedNameList`, rejected anything that
was not a single name, and looked up the unquoted result. I removed that parsing
and now pass the raw input string to `get_role_oid` / `get_namespace_oid`. The
error message also uses the raw string, and the unused `names` variables are gone.
This brings back the bug: quoted input such as `"Foo Bar"` is looked up with its
quotes, unquoted names are not downcased, and dotted names are not rejected.
This is inconsistent with the other reg* types.

The whitespace-only hunks and the regroleout/regnamespaceout cosmetic hunks are not reproduced.

Failing oracle case: src/test/regress||regproc
