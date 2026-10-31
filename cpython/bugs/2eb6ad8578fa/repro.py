import socket
sock = socket.socket(socket.AF_ALG, socket.SOCK_SEQPACKET, 0)
for addr in [("t" * 13, "name"), ("t" * 14, "name"), ("type", "n" * 63), ("type", "n" * 64)]:
    try:
        sock.bind(addr)
    except Exception as e:
        print(type(e).__name__, e)
sock.close()
