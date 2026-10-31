import socket
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
for args in [(socket.SOL_SOCKET, socket.SO_REUSEADDR, 2**100),
             (socket.SOL_SOCKET, socket.SO_REUSEADDR, {}),
             (socket.SOL_SOCKET, socket.SO_REUSEADDR, None),
             (socket.SOL_SOCKET, socket.SO_REUSEADDR, b"\0", 4)]:
    try:
        s.setsockopt(*args)
        print("ok")
    except Exception as e:
        print(type(e).__name__, e)
s.close()
