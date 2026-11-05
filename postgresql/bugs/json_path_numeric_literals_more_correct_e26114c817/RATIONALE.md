# Rationale
Changed: src/backend/utils/adt/jsonpath.c, printJsonPathItem(), case jpiNumeric.
Traces to the jsonpath.c hunk of fix_impl.patch: removed the `if (jspHasNext(v))` parenthesis output around the numeric literal. A numeric literal followed by accessors (e.g. `(1).type()`) is now printed without parentheses (`1.type()`), which is wrong and not re-parseable.
The scanner hunk was not reverted (the code evolved; minimal change kept).

Failing oracle case: src/test/regress||jsonpath
