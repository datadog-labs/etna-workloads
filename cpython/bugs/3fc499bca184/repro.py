import os, subprocess
from unittest import mock

class P(subprocess.Popen):
    def __del__(self):
        pass

def bad_error(*args):
    os.write(args[13], b"\xFF\x00\xDE\xAD")
    return 0

with mock.patch("subprocess._fork_exec", side_effect=bad_error), \
     mock.patch("subprocess.os.waitpid", side_effect=ChildProcessError):
    try:
        P(["non_existent_command"])
    except Exception as e:
        print(type(e).__name__, str(e))
