import os, subprocess, sys

code = "import os; print(','.join(str(n) for n in sorted(int(x) for x in os.listdir('/proc/self/fd') if os.path.exists('/proc/self/fd/'+x))))"
pass_fds = [os.open(os.devnull, os.O_RDWR) for _ in range(2)]
r, w = os.pipe()
pass_fds.insert(1, w)
with subprocess.Popen([sys.executable, "-c", code],
                      stdin=pass_fds[0], stdout=pass_fds[1], stderr=pass_fds[2],
                      close_fds=True, pass_fds=pass_fds):
    out = os.read(r, 1024)
fds = {int(n) for n in out.split(b',')}
print(sorted(fds - {0, 1, 2}) == sorted(set(pass_fds) - {0, 1, 2}), fds >= set(pass_fds))
print(sorted(set(pass_fds) - fds))
