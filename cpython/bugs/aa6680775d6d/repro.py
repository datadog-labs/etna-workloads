import sqlite3
con = sqlite3.connect(":memory:")
con.create_collation("mycoll", lambda x, y: (x > y) - (x < y))
con.execute("CREATE TABLE t(x TEXT)")
con.execute("INSERT INTO t VALUES ('a')")
con.execute("INSERT INTO t VALUES ('b')")
con.commit()
cur = con.execute("SELECT x FROM t ORDER BY x COLLATE mycoll")
next(cur)
try:
    con.create_collation("mycoll", lambda a, b: 0)
except sqlite3.OperationalError as e:
    print(type(e).__name__, e)
