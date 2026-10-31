import sqlite3
con = sqlite3.connect(":memory:")
def make():
    def handler():
        con.set_progress_handler(None, 0)
        raise ZeroDivisionError("boom")
    return handler
con.set_progress_handler(make(), 1)
try:
    con.execute("select 1").fetchall()
except sqlite3.Error as e:
    print(type(e).__name__, e)
con.close()
print("done")
