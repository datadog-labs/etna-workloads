# Rationale

Fix: gh-133886, sys.remote_exec() for non-UTF-8 paths.

## Hunks changed
- `Python/sysmodule.c` `sys_remote_exec_impl`: reverses the hunk that replaced
  `PyUnicode_FSDecoder` + `PyUnicode_AsUTF8(script)` with
  `PyUnicode_FSConverter` (bytes in the filesystem encoding). Restored the
  old pre-fix computation: FSDecoder, then `PyUnicode_AsUTF8(path)` for the
  C string sent to the target. (v3.15.2 has the audit call and error-path
  structure, which are kept.) Undecodable paths (surrogateescape) now fail
  with UnicodeEncodeError, and non-ASCII paths in non-UTF-8 locales are
  sent as UTF-8 instead of the FS encoding.
- `Python/ceval_gil.c` `_PyRunRemoteDebugger`: reverses
  `PyUnicode_DecodeFSDefault(path)` back to UTF-8 decoding
  (`PyUnicode_DecodeUTF8`), matching the old `PyFile_OpenCode(const char*)`
  behaviour, which decodes as UTF-8.

## Oracle
`test.test_sys.TestRemoteExec.test_remote_exec_undecodable` fails with
`UnicodeEncodeError: 'utf-8' codec can't encode character '\udce7'`. The
other 96 oracle cases pass.
