# Rationale (Lib/pdb.py only)

Reverses each implementation hunk of fix.patch:

- `setup()`: removed the `self._save_initial_file_mtime(self.curframe)` call, and the helper itself (hunk 1 and the added method).
- `_validate_file_mtime()`: restored the old docstring and made `self._file_mtime_table[filename] = mtime` unconditional again (outside the `if`).
- `onecmd()`: restored `self._validate_file_mtime()` on every command, so the warning shows on any command, not only source display.
- `_pdbcmd_print_frame_status`, `do_list`, `do_longlist`: removed the `_validate_file_mtime()` calls the fix added.

Result: the stale-code warning is again checked on every command, so a file edited and then `restart`ed immediately prints the spurious warning.

Failing oracle case: `test_file_modified_and_immediately_restarted` (stdout contains "WARNING: ... was edited").
