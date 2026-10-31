Runs `python -m pdb` on a script that raises SyntaxError (`ast.literal_eval('')`) and feeds `continue/where/quit`.
Clean: pdb enters post-mortem mode (exit 0, "Uncaught exception. Entering post mortem debugging" printed, code shown twice on stdout).
Buggy: pdb catches SyntaxError separately, prints the traceback and exits with status 1, no post-mortem.
