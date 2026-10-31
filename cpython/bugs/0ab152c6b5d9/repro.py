import socket, threading, ftplib

srv = socket.create_server(('127.0.0.1', 0))
def serve():
    c, _ = srv.accept()
    f = c.makefile('rwb')
    f.write(b'220 hi\r\n'); f.flush()
    f.readline()  # PASV
    f.write(b'227 entering passive mode (252,253,254,255,0,21)\r\n'); f.flush()
    f.readline()
    c.close()
t = threading.Thread(target=serve); t.start()
ftp = ftplib.FTP()
ftp.connect('127.0.0.1', srv.getsockname()[1], timeout=5)
host, port = ftp.makepasv()
print(host, port)
ftp.close()
t.join(); srv.close()
