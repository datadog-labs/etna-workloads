Reproducer: builds a zip containing only `a/b/c/d.py` (no directory entries) and imports `a.b.c.d` via sys.path.
Clean: prints 1 and the namespace ModuleSpec for `a`. Buggy: zipimport no longer adds implicit directories, so `a` isn't found as a namespace package and `import a.b.c.d` raises ModuleNotFoundError (exit 1).
