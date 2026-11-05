D=$(mktemp -d "${TMPDIR:-/tmp}/rXXXXXX"); cd "$D"; : > tabfile1
python3 - <<'PY'
import pty, os, select, time
pid, fd = pty.fork()
if pid == 0:
    os.environ['TERM']='dumb'
    os.execvp('psql', ['psql','-X','-q','-d','postgres'])
def rd(t=1.5):
    out=b''
    end=time.time()+t
    while time.time()<end:
        r,_,_=select.select([fd],[],[],0.2)
        if r:
            try: out+=os.read(fd,4096)
            except OSError: break
    return out
rd(2)
os.write(fd,b"COPY pg_class TO tabf\t"); o=rd()
os.write(fd,b"\x15"); rd()
os.write(fd,b"\\q\n"); rd(0.5)
print("quote added:", b"'tabfile1" in o)
PY
