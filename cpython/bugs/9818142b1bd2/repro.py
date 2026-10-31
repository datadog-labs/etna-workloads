import socket
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM | socket.SOCK_NONBLOCK)
print(s.type == socket.SOCK_STREAM, s.type)
s.setblocking(False)
print(s.type)
s.settimeout(1)
print(s.type)
s.close()
