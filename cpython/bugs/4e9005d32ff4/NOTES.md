# NOTES

`repro.py` reproduces gh-134100: a use-after-free in
`PyImport_ImportModuleLevelObject` when the module resolved by a relative
import is missing from `sys.modules`.

It puts a fake entry into `sys.modules` under the key `a.<0x23000 b's>.c`
(the dict value itself doesn't matter), then does a relative import of
`<0x23000 b's>.c` with `__package__` set to `a`. The import machinery builds
the absolute name `a.<...>.c`, looks it up as `to_return`, and since the
intermediate parent package/module was never actually imported, the final
lookup of that name in `sys.modules` fails. CPython's error path formats a
`KeyError` message with `%R` against `to_return` to report "... not in
sys.modules as expected".

In the fixed code, `to_return` is decref'd only after the error message is
formatted and only when `final_mod == NULL` isn't an error case that reuses
it further. In the buggy code (`injection.patch`), `to_return` is decref'd
unconditionally right after the `sys.modules` lookup, before the `%R`
formatting code that still reads from it runs. Because `to_return` is a
freshly built ~140KB string object with refcount 1 at that point, the decref
frees it immediately, and the subsequent `PyUnicode_FromFormat("%R not in
sys.modules as expected", to_return)` reads freed memory. The large
(`0x23000`-byte) string is used, as in the upstream test, to make the
use-after-free reliably touch unmapped/corrupted memory instead of silently
reading still-valid heap data.

Observed difference:
- `python-clean`: exits 0, deterministically prints
  `True True 143397` (sanity-checks the KeyError message's prefix/suffix and
  length).
- `python-buggy`: crashes with SIGSEGV (exit status -11) before printing
  anything, due to the use-after-free.
