import sqlite3
cx = sqlite3.connect(":memory:")
rowid = 2**32
cx.execute("create table t(t blob)")
cx.execute("insert into t(rowid, t) values (?, zeroblob(1))", (rowid,))
try:
    b = cx.blobopen('t', 't', rowid)
    print(repr(b.read()))
except Exception as e:
    print(type(e).__name__, e)
cx.close()
