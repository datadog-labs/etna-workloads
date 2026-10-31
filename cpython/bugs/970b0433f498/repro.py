import subprocess, sys
with open('s.py', 'w') as f:
    f.write("import sys; print(f'ARGS: {sys.argv[1:]}')")
for args in (['--', 's.py', '-foo'], ['--']):
    p = subprocess.run([sys.executable, '-m', 'pdb'] + args, input='c\nq\n',
                       capture_output=True, text=True)
    print(p.returncode, 'ARGS' in p.stdout, p.stderr.strip().split(': ')[-1])
