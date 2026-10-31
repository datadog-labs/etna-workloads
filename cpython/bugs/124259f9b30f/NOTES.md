Writes `nonlocal x` to a script and runs it in a subprocess. In the buggy build, run_mod
decrefs interactive_filename on compile failure even when it wasn't created, so the
interpreter crashes (refcount/assert failure) instead of printing
"SyntaxError: nonlocal declaration not allowed at module level" with exit code 1.
