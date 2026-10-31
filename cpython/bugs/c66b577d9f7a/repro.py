import os, shutil
os.mkdir('dst')
os.symlink('dst', 'link', target_is_directory=True)
try:
    shutil.move('link', 'dst')
except OSError as e:
    print(type(e).__name__)
print(sorted(os.listdir('.')), os.listdir('dst'))
