import compileall, os, py_compile
with open('m.py', 'w') as f:
    f.write('x = 1\n')
os.utime('m.py', (2**32 - 1, 2**32 - 1))
py_compile.compile('m.py')
try:
    print(compileall.compile_file('m.py', quiet=1))
except Exception as e:
    print(type(e).__name__, e)
