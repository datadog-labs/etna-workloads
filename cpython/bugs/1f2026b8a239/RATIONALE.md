# gh-137288 re-injection

## Changes
1. `Python/flowgraph.c`, `convert_pseudo_conditional_jumps()`: removed `basicblock *except = instr->i_except;` and the `.i_except = except` initialisers of the `COPY` and `TO_BOOL` instructions inserted for `JUMP_IF_FALSE/TRUE`. This reverses the fix's first flowgraph hunk. The synthesized instructions get `i_except == NULL` again, so an exception raised by `TO_BOOL` (e.g. `__bool__` raising in `a or b`) is not associated with the enclosing handler (`with`/`try`). The fix's `insert_prefix_instructions` hunks only set `.i_except = NULL` explicitly, which is the same as the zero default, so there is nothing to revert.
2. `Include/internal/pycore_magic_number.h`: bumped the magic number (3666 -> 3667, new entry), mirroring the fix's own magic bump (3653 -> 3654), because the bytecode changed.
3. `Python/import.c`: comment-only edit next to `PyImport_GetMagicNumber`. The incremental harness build does not track `pycore_magic_number.h` as a dependency of `import.o`, so without this the magic bump is not compiled in. Stale `.pyc` files from the base build, compiled with the fixed compiler, then hide the bug in `test_compile.py`. This edit has no behavioural effect.

## Oracle
`test.test_compile.TestBooleanExpression.test_exception` fails with `NotImplementedError` escaping `with self.assertRaises(NotImplementedError): c = a or b`, because the `TO_BOOL` raising is not covered by the `with` exception handler. A clean build without the magic bump also fails this test.
