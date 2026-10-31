import sqlite3
cx = sqlite3.connect(":memory:")
cu = cx.cursor()
for q in ("select ?1, ?2", "select ?2, ?1"):
    try:
        print(cu.execute(q, (1, 2)).fetchall())
    except Exception as e:
        print(type(e).__name__, e)
cx.close()
