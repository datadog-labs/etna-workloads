import subprocess, sys
with open('x.jsonl', 'w') as f:
    f.write('{"a": 1}\n{"b": 2}\n')
p = subprocess.run([sys.executable, '-m', 'json.tool', '--json-lines', 'x.jsonl'],
                   capture_output=True, text=True)
print(p.returncode)
print(p.stdout)
print(p.stderr.strip().splitlines()[-1:])
