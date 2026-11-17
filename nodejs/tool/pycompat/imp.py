# Minimal `imp` for old Node.js tools/test.py (the module was removed in Python 3.12).
# Old test.py only uses find_module/load_module to load each suite's testcfg.py.
import importlib.util
import os
import sys

PY_SOURCE = 1
PKG_DIRECTORY = 5


def find_module(name, path=None):
    for d in (path if path is not None else sys.path):
        f = os.path.join(d, name + ".py")
        if os.path.isfile(f):
            return open(f), f, (".py", "r", PY_SOURCE)
        if os.path.isfile(os.path.join(d, name, "__init__.py")):
            return None, os.path.join(d, name), ("", "", PKG_DIRECTORY)
    raise ImportError(f"No module named {name}")


def load_module(name, file, pathname, description):
    try:
        if description[2] == PKG_DIRECTORY:
            spec = importlib.util.spec_from_file_location(
                name, os.path.join(pathname, "__init__.py"), submodule_search_locations=[pathname])
        else:
            spec = importlib.util.spec_from_file_location(name, pathname)
        module = importlib.util.module_from_spec(spec)
        sys.modules[name] = module
        spec.loader.exec_module(module)
        return module
    finally:
        if file:
            file.close()


def load_source(name, pathname, file=None):
    return load_module(name, file, pathname, (".py", "r", PY_SOURCE))
