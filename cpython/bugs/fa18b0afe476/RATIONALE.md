# Rationale

Fix hunk reversed: in `Lib/pdb.py` `main()`, the fix removed the dedicated
`except SyntaxError: traceback.print_exc(); sys.exit(1)` clause so SyntaxError
falls through to `except BaseException` (post-mortem mode).

Change in v3.15.2 (`Lib/pdb.py`, `main()`): re-added that `except SyntaxError`
clause just before `except BaseException`. The restart/quit tail
(`_user_requested_quit` check) was already after the try block in v3.15.2, so
it is untouched (that was the fix's other hunk and is already equivalent).

Oracle failures: `test_issue84583` (pdb exits on the SyntaxError from
`ast.literal_eval('')` instead of entering post-mortem, so `where`/`quit`
never run and the code line count is wrong) and `test_issue16180` (post-mortem
expected, process exits with code 1). 2 failures in test_pdb.
