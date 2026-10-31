import os, sys

os.mkdir("pkg")
for name, src in {
    "__init__": "from . import a\n",
    "a": "v1: int\n\nfrom . import b\n\nv2: int\n",
    "b": "from . import a\n\nannos = a.__annotations__\n",
}.items():
    with open(f"pkg/{name}.py", "w") as f:
        f.write(src)
sys.path.insert(0, os.getcwd())
import pkg
print(pkg.a.__annotations__)
print(pkg.b.annos)
