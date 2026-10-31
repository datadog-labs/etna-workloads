# Rationale

Fix (gh-124022): `_PyCodegen_Body` used `IS_INTERACTIVE(c)` (true for the whole
compilation in "single" mode), so class bodies lost their docstring. The fix
added an `is_interactive` parameter, passed `false` for class bodies.

In v3.15.2 the parameter already exists (`codegen_body(..., is_interactive)`)
and the class body passes `false`. Reverting that is the equivalent of the
old behaviour:

- `Python/codegen.c` `codegen_class_body`: pass `_PyCompile_IsInteractive(c)`
  instead of `false` (reverses the `_PyCodegen_Body(..., false)` hunk in codegen.c).
- `Python/compile.c`, `Include/internal/pycore_compile.h`: add the accessor
  `_PyCompile_IsInteractive` returning `c->c_interactive`, i.e. the old
  `IS_INTERACTIVE(c)` value (the existing `_PyCompile_IsInteractiveTopLevel`
  is false inside nested scopes, so it can't be used).

Failing oracle cases: `test_docstring_interactive_mode` (class docstring is
None in "single" mode at opt 0/1) and `test_docstring_omitted` (NOP emitted
for the class docstring in "single" mode).
