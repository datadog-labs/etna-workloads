import socket, ssl, struct, time

ctx = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
lst = socket.socket()
lst.bind(("127.0.0.1", 0))
lst.listen(1)
client = socket.socket()
client.connect(lst.getsockname())
conn, _ = lst.accept()
client.setsockopt(socket.SOL_SOCKET, socket.SO_LINGER, struct.pack("ii", 1, 0))
client.send(b"DELETE /data HTTP/1.0\r\n\r\n")
client.close()  # RST
time.sleep(0.5)
try:
    s = ctx.wrap_socket(conn, server_side=True)
except OSError as e:
    print(type(e).__name__, getattr(e, "reason", None))
else:
    print("no error")
    s.close()
conn.close()
lst.close()
