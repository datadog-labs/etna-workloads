Reproducer: writes a module with `def before()` followed by a class whose body stores
`sys._getframe(0).f_code` (a class code object), then calls `inspect.getsource` / `findsource` on it.
Clean: returns the class source, lineno 3. Buggy: findsource walks backwards looking for a
def/lambda/decorator line and returns `def before():...`, lineno 0.
