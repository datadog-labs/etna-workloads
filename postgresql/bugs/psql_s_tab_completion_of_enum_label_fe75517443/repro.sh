psql -X -q -c "CREATE TYPE enum1 AS ENUM ('foo','bar','baz')" postgres
cat > "$PWD/drv.py" <<'PY'
import pty, os, sys, time, select, re
pid, fd = pty.fork()
if pid == 0:
    os.environ['TERM']='dumb'; os.environ['PSQL_HISTORY']='/dev/null'
    os.execvp('psql', ['psql','-X','-q','postgres'])
def rd(t=1.0):
    out=b''
    while select.select([fd],[],[],t)[0]:
        try: d=os.read(fd,4096)
        except OSError: break
        if not d: break
        out+=d
    return out
rd(1.5)
def t(s):
    os.write(fd,s.encode()); return rd(1.0)
o=t("ALTER TYPE enum1 RENAME VALUE 'ba\t\t")
os.write(fd,b"\x15"); rd(0.5)
o2=t("ALTER TYPE enum1 RENAME VALUE 'zzz\t")
os.write(fd,b"\x15\\q\n"); rd(0.5)
print(repr(o.decode()))
print(repr(o2.decode()))
PY
python3 "$PWD/drv.py"
rm -f "$PWD/drv.py"
