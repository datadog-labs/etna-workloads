# Rationale

Reverses the `find_function` hunk of fix.patch in `Lib/pdb.py`. The fix made
`find_function` accumulate the function source, compile it and return
`funcstart + first_executable_line - 1`. In v3.15.2 I removed that
accumulate/compile logic (`funcdef`/`funcstart`) and return
`funcname, filename, lineno` of the `def` line again, as before the fix.

`find_first_executable_line` is left in place because `do_break` uses it
for function objects (that was already the pre-fix behaviour via the method).
The `break func` path through `lineinfo` -> `find_function` therefore puts the
breakpoint on the `def` line instead of the first executable line.

Failing oracle cases include `test_find_function_first_executable_line`,
`test_find_function_found`, `test_find_function_found_with_bom` and
`test_find_function_found_with_encoding_cookie`. They return the `def` line
number instead of the first body line. Other pdb tests that break on a function
by name also fail. `test_nonexistent_module` appears in the failure output
too, but I did not check whether it is related to this change.
