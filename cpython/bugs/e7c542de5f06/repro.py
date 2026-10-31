import os, subprocess, sys, tempfile

with tempfile.TemporaryDirectory() as d:
    script = os.path.join(d, "startup.py")
    with open(script, "w") as f:
        f.write("print('should not print')\n")
    env = os.environ.copy()
    env["PYTHON_HISTORY"] = os.path.join(d, ".hist")
    env["PYTHONSTARTUP"] = script
    p = subprocess.run([sys.executable, "-I", "-m", "asyncio"], input="", env=env,
                       capture_output=True, text=True, cwd=d)
    print(p.returncode, "should not print" in p.stdout + p.stderr)
