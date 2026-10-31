import os, shutil
os.mkdir('src')
open(os.path.join('src', 'foo'), 'w').close()

def cp(a, b):
    print(type(a).__name__, type(b).__name__)
    print(a, b)

shutil.copytree('src', 'dst', copy_function=cp)
