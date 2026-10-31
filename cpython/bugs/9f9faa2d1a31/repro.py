import os, select, errno

ep = select.epoll()
os.close(ep.fileno())
try:
    ep.close()
except OSError as e:
    print("OSError", e.errno == errno.EBADF)
else:
    print("no error")
