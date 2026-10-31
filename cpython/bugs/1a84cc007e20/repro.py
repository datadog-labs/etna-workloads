import subprocess, sys
code = """if 1:
import _thread
class Foo():
    def __del__(self):
        _thread.interrupt_main()

x = Foo()
""".replace("if 1:\n", "", 1)
p = subprocess.run([sys.executable, '-c', code], capture_output=True, text=True)
print(p.returncode)
print('OSError: Signal 2 ignored due to race condition' in p.stderr)
