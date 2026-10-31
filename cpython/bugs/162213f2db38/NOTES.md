Runs `python -m pdb` on a nonexistent module and on a directory, printing the exit status and last stdout line.
Clean: "ImportError: No module named ..." and "Error: d is a directory". Buggy: the module case prints a traceback to stderr (stdout empty), and the directory case is not reported as a directory.
