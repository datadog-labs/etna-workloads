import _socket, importlib, socket

if hasattr(_socket, 'socketpair'):
    del _socket.socketpair
    socket = importlib.reload(socket)

orig = socket.socket.getsockname
inject = None

def hooked(self):
    global inject
    name = orig(self)
    if inject is None:
        inject = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        inject.setblocking(False)
        try:
            inject.connect(name[:2])
        except (BlockingIOError, InterruptedError):
            pass
        inject.setblocking(True)
    return name

socket.socket.getsockname = hooked
try:
    a, b = socket.socketpair()
    print("socketpair succeeded")
    a.close(); b.close()
except OSError as e:
    print("OSError:", e)
finally:
    socket.socket.getsockname = orig
    if inject:
        inject.close()
