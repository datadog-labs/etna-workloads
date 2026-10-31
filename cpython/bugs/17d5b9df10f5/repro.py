import zipfile, zipimport, sys
with zipfile.ZipFile('t.zip', 'w') as z:
    z.writestr('a/b/c/d.py', 'x = 1\n')
zi = zipimport.zipimporter('t.zip/a')
sys.path.insert(0, 't.zip')
import a.b.c.d
print(a.b.c.d.x)
print(repr(zipimport.zipimporter('t.zip').find_spec('a')))
