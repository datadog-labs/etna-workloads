import compileall, os, marshal
os.makedirs("a/build/real/path")
with open("a/build/real/path/m.py", "w") as f: f.write("x = 1\n")
compileall.compile_file("a/build/real/path/m.py", quiet=2, force=True,
                        stripdir="a/build/fake")
import importlib.util
with open(importlib.util.cache_from_source("a/build/real/path/m.py"), "rb") as f:
    f.read(16)
    print(marshal.load(f).co_filename)
