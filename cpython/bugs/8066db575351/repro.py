# pdb can't be imported here (bdb.py in the build's Lib is broken), so
# extract _pyrepl_available from pdb.py's source and run it directly.
import ast, os, sys, types, sysconfig, importlib.util
with open(importlib.util.find_spec("pdb").origin) as fh:
    src = fh.read()
fn = next(n for n in ast.parse(src).body
          if isinstance(n, ast.FunctionDef) and n.name == "_pyrepl_available")
ns = {"os": os, "sys": sys}
exec(compile(ast.Module([fn], []), "pdb", "exec"), ns)
f = ns["_pyrepl_available"]

os.environ["PYTHON_BASIC_REPL"] = "1"
print(f())
del os.environ["PYTHON_BASIC_REPL"]
mod = types.ModuleType("_pyrepl.main")
mod.CAN_USE_PYREPL = True
sys.modules["_pyrepl.main"] = mod
print(f())
