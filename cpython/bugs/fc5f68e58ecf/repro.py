import os, unittest

os.makedirs('proj/pkg')
for name in ('proj/pkg/__init__.py', 'proj/pkg/test_a.py'):
    with open(name, 'w'):
        pass
loader = unittest.TestLoader()
loader.discover('proj/pkg', top_level_dir='proj')
print(repr(loader._top_level_dir))
