import subprocess, sys

src = """\
from contextvars import ContextVar
var = ContextVar("var", default="failed")
var.set("ok")
print(f"toplevel contextvar test: {var.get()}")
"""
src2 = "print(f'second: {var.get()}')\n"
p = subprocess.run([sys.executable, "-m", "asyncio"], input=src + "\n" + src2,
                   capture_output=True, text=True, env={"PYTHON_BASIC_REPL": "1", "PYTHONHASHSEED": "0"})
print(p.returncode)
print([l for l in (p.stdout + p.stderr).splitlines() if "toplevel" in l or "second" in l or "Error" in l])
