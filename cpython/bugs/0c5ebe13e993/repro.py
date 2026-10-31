import importlib.machinery, importlib.util, importlib._bootstrap, _testsinglephase

name = '_testsinglephase_check_cache_first'
loader = importlib.machinery.ExtensionFileLoader(name, _testsinglephase.__file__)
spec = importlib.util.spec_from_file_location(name, _testsinglephase.__file__, loader=loader)
mod = importlib._bootstrap._load(spec)
print(mod.__name__)
