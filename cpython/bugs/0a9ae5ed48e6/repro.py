import os, subprocess, sys, tempfile

with tempfile.TemporaryDirectory() as tmp:
    sub = os.path.join(tmp, "subtmp")
    os.mkdir(sub)
    with open(os.path.join(sub, "main.py"), "w") as f:
        f.write("import os, shutil\nshutil.rmtree(os.getcwd())\nos.does_not_exist\n")
    p = subprocess.run([sys.executable, "-c", "import main"], cwd=sub,
                       capture_output=True, text=True)
    print(p.returncode < 0, p.returncode)
    print(p.stderr.strip().splitlines()[-1] if p.stderr.strip() else "")
