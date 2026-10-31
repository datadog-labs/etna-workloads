import subprocess, sys
for src in ["\n'''\nmultilinestring\0\n'''", "\nf'''\nmultilinestring\0\n'''"]:
    with open('script.py', 'w') as f:
        f.write(src)
    p = subprocess.run([sys.executable, 'script.py'], capture_output=True)
    print(p.returncode, p.stderr.splitlines()[-2:])
