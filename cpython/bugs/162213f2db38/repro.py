import subprocess, sys, os
os.mkdir("d")
for args in (["-m", "nonexistent_mod_xyz"], ["d"]):
    r = subprocess.run([sys.executable, "-m", "pdb", *args], input="", capture_output=True, text=True)
    print(args, r.returncode)
    print(r.stdout.strip().splitlines()[-1:])
