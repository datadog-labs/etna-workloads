import sqlite3
cx = sqlite3.connect(":memory:")
cu = cx.cursor()
print(repr(cu.description))
row = sqlite3.Row(cu, ())
try:
    print(repr(row.keys()))
except Exception as e:
    print(type(e).__name__, e)
try:
    row["nokey"]
except Exception as e:
    print(type(e).__name__, e)
cx.close()
