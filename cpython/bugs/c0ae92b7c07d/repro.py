import os
import stat
import dbm.sqlite3 as dbm_sqlite3

os.mkdir("d")
path = os.path.join("d", "test.db")
with dbm_sqlite3.open(path, "c") as db:
    db[b"key"] = b"value"

os.chmod("d", stat.S_IREAD | stat.S_IEXEC)
try:
    with dbm_sqlite3.open(path, "r") as db:
        print(repr(db[b"key"]))
except Exception as e:
    print(type(e).__name__, e)
os.chmod("d", stat.S_IRWXU)
