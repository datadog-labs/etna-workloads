import fcntl, os
r, w = os.pipe()
os.close(r)
for arg in (b'\0' * 10, b'\0' * 2048):
    try:
        fcntl.fcntl(r, fcntl.F_DUPFD, arg)
    except Exception as e:
        print(type(e).__name__, e)
