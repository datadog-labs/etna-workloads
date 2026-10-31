import _thread
h = _thread._ThreadHandle()
try:
    h._set_done()
    print("no error")
except RuntimeError as e:
    print("RuntimeError:", e)
