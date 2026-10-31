# What repro.py does

Creates an anonymous `mmap.mmap(-1, 16)`, then calls `m.find(b"a", EvilIndex())`
where `EvilIndex.__index__` closes the mmap (and so frees/munmaps its
backing buffer) before returning the start index.

`mmap_find_method` converts the `start` argument via `__index__` *after* its
first `CHECK_VALID(NULL)` call, so by the time it computes `self->data +
start` and scans for the needle, the mmap has already been closed/unmapped.
The upstream fix (2023-05-19, gh-103987) added a second `CHECK_VALID(NULL)`
right before that use, specifically to catch mmaps closed via a malicious
`__index__` during argument conversion. `injection.patch` removes that
second check (along with the analogous ones in `__getitem__`/`__setitem__`
and slicing), reopening the use-after-free.

# Observed difference

- `bin/python-clean` (fix applied): raises `ValueError: mmap closed or
  invalid`, exit status 0.
- `bin/python-buggy` (injection.patch applied): the find proceeds against
  the freed mapping and the process crashes with SIGSEGV, exit status -11.
