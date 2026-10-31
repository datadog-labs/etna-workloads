import os, subprocess, sys

os.mkdir('sub')
with open('sub/s.py', 'w') as f:
    f.write("import sys\nprint('P0 is sub:', sys.path[0].endswith('sub'))\n")
env = dict(os.environ, PYTHONSAFEPATH='1')
p = subprocess.run([sys.executable, '-m', 'pdb', 'sub/s.py'], input='c\n',
                   capture_output=True, text=True, env=env)
print('P0 is sub: True' in p.stdout)
