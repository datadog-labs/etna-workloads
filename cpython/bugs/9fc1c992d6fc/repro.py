import os, subprocess, sys

build = os.path.dirname(os.path.realpath(sys.executable))
exe = os.path.join(build, "Programs", "_testembed")
code = """
import _ssl
_ssl.txt2obj(txt='1.3')
print('1')

import _queue
_queue.SimpleQueue().put_nowait(item=None)
print('2')

import _zoneinfo
_zoneinfo.ZoneInfo.clear_cache(only_keys=['Foo/Bar'])
print('3')
"""
p = subprocess.run([exe, "test_repeated_init_exec", code],
                   stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, cwd=build)
print(p.stdout)
print("exit status:", p.returncode)
