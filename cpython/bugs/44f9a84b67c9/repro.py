import os, subprocess, sys

with open('main.py', 'w') as f:
    f.write("""
class A:
    def __init__(self):
        self.attr = 1
a = A()
b = 2
""")
with open('.pdbrc', 'w') as f:
    f.write("b 6\ncommands 1 ;; p a;; end\nc\n")
env = {k: v for k, v in os.environ.items() if k != 'HOME'}
p = subprocess.run([sys.executable, '-m', 'pdb', 'main.py'], input='q\n',
                   capture_output=True, text=True, env=env)
out = p.stdout + p.stderr
print("A object printed:", "<__main__.A object at" in out)
