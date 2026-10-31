import subprocess, sys
with open("s.py", "w") as f:
    f.write("import sys\nprint(sys.argv[1:])\n")
p = subprocess.run([sys.executable, "-m", "pdb", "s.py", "--bar", "foo"],
                   input="continue\nquit\n", capture_output=True, text=True)
print(p.returncode)
print("['--bar', 'foo']" in p.stdout)
print(p.stderr.strip().splitlines()[-1:] and "stderr non-empty")
