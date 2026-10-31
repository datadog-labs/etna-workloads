import subprocess, sys
with open('s.py', 'w') as f:
    f.write("import ast; ast.literal_eval('')\n")
p = subprocess.run([sys.executable, '-m', 'pdb', 's.py'], input="continue\nwhere\nquit\n",
                   capture_output=True, text=True)
print(p.returncode)
print("Uncaught exception. Entering post mortem debugging" in p.stdout)
print(p.stdout.count("ast.literal_eval('')"))
