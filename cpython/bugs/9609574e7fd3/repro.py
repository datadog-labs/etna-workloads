import os, sys

class MyPath:
    def __fspath__(self):
        mutated.clear()
        return b"pwn"

mutated = KEYS = VALUES = [MyPath()]

class MyEnv:
    def __getitem__(self): raise RuntimeError("must not be called")
    def __len__(self): return 1
    def keys(self): return KEYS
    def values(self): return VALUES

args = [sys.executable, '-c', "print('hello from execve')"]
sys.stdout.flush()
os.execve(args[0], args, MyEnv())
