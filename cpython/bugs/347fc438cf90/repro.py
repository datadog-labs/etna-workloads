import os, sys
for kw in ({'setpgroup': None}, {'scheduler': None}, {'scheduler': 1}, {'scheduler': [1, 2]}):
    try:
        pid = os.posix_spawn(sys.executable, [sys.executable, '-c', 'pass'], os.environ, **kw)
        print(kw, os.waitpid(pid, 0)[1])
    except BaseException as e:
        print(kw, type(e).__name__, e)
