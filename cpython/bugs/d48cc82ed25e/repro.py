import os, shlex, subprocess, venv

name = '"\';&&$e|\'"'
env_dir = os.path.join(os.path.realpath('.'), name)
venv.EnvBuilder(clear=True).create(env_dir)
activate = os.path.join(env_dir, 'bin', 'activate')
with open('t.sh', 'w') as f:
    f.write(f'source {shlex.quote(activate)}\n'
            'echo "$VIRTUAL_ENV"\n')
r = subprocess.run(['bash', 't.sh'], capture_output=True, text=True)
print(r.returncode)
print(r.stdout.replace(os.path.realpath('.'), '<cwd>'))
print(r.stderr.replace(os.path.realpath('.'), '<cwd>'))
