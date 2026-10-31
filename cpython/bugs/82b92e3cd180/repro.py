import socket

class Mut:
    def __index__(self):
        seq.clear()
        return socket.SCM_RIGHTS

seq = [
    (socket.SOL_SOCKET, Mut(), b'xxxx'),
    (socket.SOL_SOCKET, socket.SCM_RIGHTS, b'xxxx'),
]
left, right = socket.socketpair()
try:
    left.sendmsg([b'x'], seq)
except OSError as e:
    print("OSError")
left.close()
right.close()
