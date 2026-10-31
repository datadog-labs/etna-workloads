import os, zipapp, zipfile
os.mkdir('src')
open('src/__main__.py', 'w').close()
open('src/test.py', 'w').close()
zipapp.create_archive('src', 'src/target.pyz')
with zipfile.ZipFile('src/target.pyz') as z:
    print(sorted(z.namelist()))
