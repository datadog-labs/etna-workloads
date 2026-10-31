# Rationale (gh-124703, pdb quit in inline mode)

Changes, all in `Lib/pdb.py`:

1. `do_quit`: removed the `if self.mode == 'inline' ...` confirmation block
   (the fix's first hunk added it; v3.15.2 had a later variant with the
   `sys.ps1` check and `sys.exit(1)`). Quit in inline mode again just sets
   `_user_requested_quit`/`set_quit()`, so a BdbQuit traceback is raised
   instead of a prompt and graceful exit.
2. `do_EOF`: restored the old body (set `_user_requested_quit`, `set_quit()`,
   `return 1`) in place of `return self.do_quit(arg)` (fix's second hunk).

Failing oracle cases: `PdbTestInline.test_quit` (no "Quit anyway" prompt;
traceback on stderr), `PdbTestInline.test_quit_after_interact`
(stderr contains a BdbQuit traceback instead of being empty).
