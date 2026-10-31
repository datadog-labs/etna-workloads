# Rationale

Fix gh-121604 added missing DeprecationWarnings in importlib. Reintroduced by removing them:

- `Lib/importlib/machinery.py`: reverses the machinery.py hunk. `DEBUG_BYTECODE_SUFFIXES` and
  `OPTIMIZED_BYTECODE_SUFFIXES` are plain re-exported names again, and the warning `__getattr__` is removed.
  (`inspect.getsourcefile` already uses `BYTECODE_SUFFIXES`, so the inspect hunk needs no change.)
- `Lib/importlib/abc.py`: reverses the `SourceLoader.path_mtime` hunk by removing its DeprecationWarning.

Not changed: the `ResourceLoader.__init__` warning is already absent in v3.15.2, and the
`WindowsRegistryFinder.find_spec` warning was left in place (Windows-only).

Oracle failures: `test_api.TestDeprecations.test_machinery_deprecated_attributes` (both subtests,
"DeprecationWarning not triggered"). The `SourceLoaderDeprecationWarningsTests.test_deprecated_path_mtime`
case in test_abc should also fail for the same reason.
