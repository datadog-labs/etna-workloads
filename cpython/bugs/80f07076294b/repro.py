import compileall, contextlib, io
with open('bad.py', 'w') as f:
    f.write('x = (\n')
with contextlib.redirect_stdout(io.StringIO()):
    r = compileall.compile_file('bad.py')
print(repr(r))
