import _testsinglephase, _interpreters

script = f"""
import importlib.util, importlib.machinery
name = '_testsinglephase_raise_exception'
loader = importlib.machinery.ExtensionFileLoader(name, {_testsinglephase.__file__!r})
spec = importlib.util.spec_from_loader(name, loader)
importlib.util.module_from_spec(spec)
"""
interp = _interpreters.create()
try:
    exc = _interpreters.run_string(interp, script)
finally:
    _interpreters.destroy(interp)
print(exc.type.__name__, exc.msg)
