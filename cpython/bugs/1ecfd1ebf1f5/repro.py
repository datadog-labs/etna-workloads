import compileall, os, pathlib
os.mkdir('d')
with open('d/m.py','w') as f: f.write('x=1\n')
try:
    print(compileall.compile_file(pathlib.Path('d/m.py'), stripdir=pathlib.Path('d'), quiet=2))
except Exception as e:
    print(type(e).__name__, e)
