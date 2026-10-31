import os, subprocess, tempfile, _ctypes
from ctypes import CDLL, c_int

SRC = r"""
#include <unistd.h>
asm (".type foo STT_GNU_IFUNC");
void *foo(void) { write($FD, "OK", 2); return NULL; }
"""

r, w = os.pipe()
with tempfile.TemporaryDirectory() as d:
    src = os.path.join(d, 'foo.c')
    lib = os.path.join(d, 'libfoo.so')
    with open(src, 'w') as f:
        f.write(SRC.replace('$FD', str(w)))
    subprocess.run(['gcc', '-fPIC', '-shared', '-o', lib, src], check=True)

    L = CDLL(lib)
    try:
        L.foo
        print("no error")
    except AttributeError as e:
        print("AttributeError:", e)
    print(os.read(r, 2))
    try:
        c_int.in_dll(L, "foo")
        print("no error")
    except ValueError as e:
        print("ValueError:", e)
    print(os.read(r, 2))
    h = _ctypes.dlopen(lib)
    try:
        _ctypes.dlsym(h, "foo")
        print("no error")
    except OSError as e:
        print("OSError:", e)
    print(os.read(r, 2))
