# Rationale (gh-143650)

Fix hunks reversed (both in Python/import.c; the C code in v3.15.2 still had them, so they were removed directly):

1. `PyImport_GetModule`: removed the post-`import_ensure_initialized()` re-check of `sys.modules` (`mod_check != mod` -> return NULL). It now returns the module it found even if another thread removed it after a failed import.
2. `PyImport_ImportModuleLevelObject`: removed the same re-check and the retry via `import_find_and_load()`. The unrelated lazy-submodule clearing that v3.15.2 added in the `else` branch is kept, just un-nested.

The `Lib/importlib/_bootstrap.py` hunk was not reverted: `_find_and_load` was rewritten (it re-reads sys.modules under the module lock), so the Python path is covered differently. `__import__` in the test goes through the C path.

## Oracle
`test_import_failure_race_condition` fails (stale module returned though not in sys.modules). The other 19 listed cases also fail in the run, apparently as a cascade from the same test (leaked threads / dangling-thread checks); I did not confirm this by running them in isolation.
