import pkgutil
from pathlib import Path
try:
    print(repr(pkgutil.get_importer(Path("/home"))))
except Exception as e:
    print(type(e).__name__, e)
print(list(pkgutil.iter_modules([Path(".")])))
