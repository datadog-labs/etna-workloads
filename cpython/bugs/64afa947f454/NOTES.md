repro.py writes a sitecustomize.py (run during `import site`, i.e. during init) to a temp dir
and runs a child interpreter with PYTHONPATH pointing at it. The hook calls
`ctypes.pythonapi.Py_IsInitialized()` and prints the result.

Clean: prints 0 (initialized flag set only at end of init_interp_main).
Buggy: prints 1 (flag set before site import).
