repro.py builds a shared lib with a GNU IFUNC `foo` that returns NULL (gcc required), then
looks it up via CDLL attribute access, c_int.in_dll, and _ctypes.dlsym.
Clean: each raises "not found" (AttributeError/ValueError/OSError) and the IFUNC ran each time.
Buggy: dlsym's NULL result isn't treated as "not found" (stale/NULL dlerror used), and the
process crashes with SIGSEGV (exit -11) on the first lookup.
