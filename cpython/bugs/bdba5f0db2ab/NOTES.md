## What the reproducer does

`repro.py` builds a `types.GenericAlias(int, lst)` where `lst` is a list
containing an object `X()` whose `__repr__` clears `lst` (removing itself
and the other element), followed by the int `1`. It then calls `repr(ga)`.

`GenericAlias.__repr__` iterates over its `__args__` list by index, calling
`repr()` on each element to build the `int[x, 1]`-style string. Rendering
the first element (`X()`) triggers `lst.clear()` as a side effect, shrinking
the underlying list out from under the iteration that is still in progress.

## What differs between the interpreters

- **python-clean** (fixed): the repr-building code fetches each item with
  `PyList_GetItemRef`, which takes a strong reference and bounds-checks on
  every access. After the callback shrinks the list, the next index access
  is caught and raises `IndexError: list index out of range`, which
  propagates out of `repr(ga)`. Exit status 0, deterministic output.

- **python-buggy** (`injection.patch` applied): the repr-building code uses
  `PyList_GET_ITEM`, a macro that reads a raw borrowed pointer out of the
  list's backing array without bounds-checking. Once the callback shrinks
  the list, continuing to index into it reads past the (now smaller)
  backing array, dereferencing garbage/freed memory. This crashes the
  process — observed as the interpreter exiting with status -11 (SIGSEGV)
  under the debug build.

`./check.sh` shows this concretely: python-clean exits 0 and prints
`IndexError: list index out of range`; python-buggy exits with status -11
(segfault) and prints nothing comparable.
