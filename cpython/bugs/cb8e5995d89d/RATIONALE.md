# Rationale

Hunk reversed: `Lib/pathlib/__init__.py`, `PurePath.__init__` (the fix's only implementation hunk; the code moved from `_local.py` to `__init__.py`).
The flavour check goes back from `arg.parser is not self.parser` to `arg.parser is ntpath and self.parser is posixpath`.
The conversion goes back from `paths.append(arg.as_posix())` to `paths.extend(path.replace('\\', '/') for path in arg._raw_paths)`.
With this, a `PurePath` of a different flavour is again joined from its `_raw_paths` whenever the flavours differ in a direction other than nt to posix.
For example, `WindowsPath(PosixPath('b', 'c:', 'd'))` joins the segments with Windows rules, so 'c:' resets the drive.
The result is `c:/d` instead of `b/c:/d`.

Oracle failure: `PureWindowsPathTest.test_constructor_nested_foreign_flavour` fails with `PureWindowsPath('c:/d') != PureWindowsPath('b/c:/d')`.
check.sh reports 1 failure and 3 errors in test_pathlib.test_pathlib.
