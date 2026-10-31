import os, pathlib, shutil
os.mkdir('d')
open('f', 'w').close()
try:
    shutil.move(pathlib.Path('f'), 'd')
    print(os.listdir('d'))
except Exception as e:
    print(type(e).__name__, e)
