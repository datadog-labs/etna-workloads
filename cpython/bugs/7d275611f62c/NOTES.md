Runs a script that calls breakpoint() under pdb, feeding "quit", "n", "p x + 1", "quit", "y" on stdin.
Clean: the inline-mode "Quitting pdb will kill the process. Quit anyway? [y/n]" prompt appears twice; exit status 1, empty stderr.
Buggy: do_quit no longer prompts (prompt count 0) and the child dies with a BdbQuit traceback on stderr.
