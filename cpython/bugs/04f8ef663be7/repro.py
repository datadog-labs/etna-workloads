import os, subprocess, sys, tempfile

exe = os.path.realpath(sys.executable)
with tempfile.TemporaryDirectory() as d:
    script = os.path.join(d, "pythonstartup.py")
    with open(script, "w") as f:
        f.write("def foo():\n    1/0\n")
    env = os.environ.copy()
    env["PYTHONSTARTUP"] = script
    env["PYTHON_HISTORY"] = os.path.join(d, ".pythonhist")
    env["PYTHONPATH"] = os.pathsep.join(p for p in sys.path if p)
    p = subprocess.run(
        [os.path.join(os.path.dirname(exe), "<stdin>"), "-i"],
        executable=exe, input="foo()\n", text=True,
        stdout=subprocess.PIPE, stderr=subprocess.STDOUT, env=env, cwd=d)
    print(p.stdout.replace(d, "TMP").split(">>> ", 1)[1].strip())
