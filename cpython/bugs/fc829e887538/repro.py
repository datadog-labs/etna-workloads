import os, shutil, zipfile
with zipfile.ZipFile('t.zip', 'w') as zf:
    zf.writestr('good/file', 'x')
    zf.writestr('good..file', 'x')
    zf.writestr('C:/abspath', 'x')
    zf.writestr('/abs', 'x')
    zf.writestr('../rel', 'x')
shutil.unpack_archive('t.zip', 'dst')
for r, d, f in sorted(os.walk('dst')):
    for n in sorted(f):
        print(os.path.join(r, n))
print(os.path.exists('rel'), os.path.exists('abs'))
