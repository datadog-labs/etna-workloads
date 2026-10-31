import warnings
with warnings.catch_warnings(record=True) as wlog:
    warnings.simplefilter('error')
    warnings.filterwarnings('always', module=r'pkg\.mod\z')
    warnings.warn_explicit('hi', UserWarning, 'a/b/pkg/mod.py', 1)
    warnings.warn_explicit('init', UserWarning, 'pkg/mod/__init__.py', 2)
print([(str(w.message), w.filename) for w in wlog])
