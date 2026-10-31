import sys
import importlib.util
from importlib.machinery import ExtensionFileLoader
import _testsinglephase

name = '_testsinglephase_circular'
loader = ExtensionFileLoader(name, _testsinglephase.__file__)
spec = importlib.util.spec_from_loader(name, loader)
mod = importlib.util.module_from_spec(spec)
loader.exec_module(mod)
print(mod.helper_mod_name)
print(name in sys.modules)
