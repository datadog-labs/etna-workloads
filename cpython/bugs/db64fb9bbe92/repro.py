import subprocess, sys
try:
    out = subprocess.check_output([sys.executable, "-c", "print('foo')"],
                                  input=None, encoding='utf-8', errors='ignore')
    print(repr(out))
except Exception as e:
    print(type(e).__name__, e)
