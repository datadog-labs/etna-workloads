from sqlite3.__main__ import SqliteInteractiveConsole
import sqlite3, io, contextlib
con = sqlite3.connect(":memory:")
c = SqliteInteractiveConsole(con)
for s in (".version ", ". version", ".unknown", ".", " "):
    out = io.StringIO()
    with contextlib.redirect_stdout(out), contextlib.redirect_stderr(out):
        try:
            r = c.runsource(s)
        except BaseException as e:
            r = repr(e)
    print(repr(s), r, repr(out.getvalue()))
con.close()
