import os, sys, tempfile, importlib
from _pyrepl._module_completer import ModuleCompleter

with tempfile.TemporaryDirectory() as d1, tempfile.TemporaryDirectory() as d2:
    sys.path[:0] = [d2, d1]
    os.mkdir(os.path.join(d1, "mymodule"))
    open(os.path.join(d1, "mymodule", "__init__.py"), "w").close()
    open(os.path.join(d1, "mymodule", "foo.py"), "w").close()
    importlib.import_module("mymodule")
    os.mkdir(os.path.join(d2, "mymodule"))
    open(os.path.join(d2, "mymodule", "__init__.py"), "w").close()
    open(os.path.join(d2, "mymodule", "bar.py"), "w").close()
    importlib.invalidate_caches()
    print(ModuleCompleter()._find_modules("mymodule", ""))
