# NOTES

`repro.py` compiles a function with 20 context managers in a single
`async with (...)` statement (a generator function, so the `with` turns
into a `SETUP_WITH`/exception-table block per context manager during
compilation):

```python
async def f():
    async with (a, a, a, ..., a):  # 20 context managers
        yield 1
```

This matches the `CO_MAXBLOCKS` (20) static nesting limit used by the
compiler's `_PyCfgExceptStack`.

- On `python-clean` (fix applied), compilation succeeds and the script
  prints `ok` and exits 0.
- On `python-buggy` (injection.patch reverted the fix), the except-handler
  stack array `handlers[CO_MAXBLOCKS+1]` is one element too small for the
  push that happens when nesting reaches exactly `CO_MAXBLOCKS`, and the
  missing `assert(stack->depth <= CO_MAXBLOCKS)` guard lets it write one
  element past the end of the array in `push_except_block`. This corrupts
  adjacent stack state, and the interpreter crashes with a segfault
  (`check.sh` reports `python-buggy: exit status -11`) while compiling the
  same source that the clean build compiles without error.

The reproducer is a minimized version of the upstream test
`test_with_statement_many_context_managers` added by `fix.patch`,
using the `async with` variant that triggers the crash directly (the
`with` test with 19 managers compiles fine on both interpreters;
using `async with` with 20 managers adds enough implicit exception-table
nesting from the async context manager machinery to overflow the
one-element-too-small array).
