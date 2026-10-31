# Rationale

In `Python/symtable.c`, `symtable_extend_namedexpr_scope` (the helper `symtable_lookup_entry` still exists in v3.15.2), two lookups were reverted to the pre-fix unmangled form:

1. Comprehension conflict check: `symtable_lookup_entry(st, ste, target_name)` -> `_PyST_GetSymbol(ste, target_name)`. Reverses the first fix hunk at that call site. The symbol table stores mangled names, so an unmangled `__x` is never found and the "cannot rebind comprehension iteration variable" check is skipped.
2. FunctionBlock global/nonlocal lookup: same replacement. Reverses the second hunk. A mangled global such as `_Foo__x1` is no longer found via `__x1` inside a class method.

Oracle failure: `NamedExpressionInvalidTest.test_named_expression_invalid_mangled_class_variables` fails with "SyntaxError not raised". The other 73 cases pass. `test_named_expression_scope_mangled_names` is not in the failing set.
