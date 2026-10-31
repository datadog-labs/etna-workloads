import subprocess, sys
cases = ["for a in b:\n  pass\nelso:\n  pass", "if x:\n  pass\nelseif y:\n  pass",
         "def foo():\n  returm result", "[x for x\nin range(3)\nof x]"]
for i, code in enumerate(cases):
    with open(f"s{i}.py", "w") as f:
        f.write(code)
    p = subprocess.run([sys.executable, f"s{i}.py"], capture_output=True, text=True)
    print(i, "Did you mean" in p.stderr, p.stderr.strip().splitlines()[-1])
