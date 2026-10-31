import sqlite3
cx = sqlite3.connect(":memory:")
cx.execute("create table test(b blob)")
cx.execute("insert into test(b) values (?)", (b"abc",))
with cx.blobopen("test", "b", 1) as blob:
    print(repr(blob[5:-5]))
cx.close()
