import warnings
from importlib.abc import SourceLoader
from importlib import machinery

class L(SourceLoader):
    def get_data(self, path): return b''
    def get_filename(self, fullname): return 'foo.py'
    def path_stats(self, path): return {'mtime': 1}

for name, f in [('path_mtime', lambda: L().path_mtime('foo.py')),
                ('DEBUG', lambda: machinery.DEBUG_BYTECODE_SUFFIXES),
                ('OPT', lambda: machinery.OPTIMIZED_BYTECODE_SUFFIXES)]:
    with warnings.catch_warnings(record=True) as w:
        warnings.simplefilter('always')
        r = f()
    print(name, r, [x.category.__name__ for x in w])
