import subprocess, sys
script = """
import datetime
from _ast import Tuple
f = lambda: None
Tuple.dims = property(f, f)

class tzutc(datetime.tzinfo):
    pass
"""
p = subprocess.run([sys.executable, '-c', script], capture_output=True, text=True)
print(p.returncode)
print(p.stderr[-300:] if p.returncode else p.stdout)
