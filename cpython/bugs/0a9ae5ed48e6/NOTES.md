Runs `python -c "import main"` in a subdirectory whose main.py deletes the cwd and then accesses `os.does_not_exist`.
Clean: prints the normal `AttributeError: module 'os' has no attribute 'does_not_exist'` (exit 1).
Buggy: `_PyModule_IsPossiblyShadowing` returns -1 on getcwd failure without an exception set, so the debug build hits `assert(PyErr_Occurred())` and aborts.
