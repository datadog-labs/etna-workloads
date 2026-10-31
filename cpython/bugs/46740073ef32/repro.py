import sqlite3
cx = sqlite3.connect(":memory:")
cx.execute("create table test(name)")
cu = cx.cursor()
cu.execute("-- foo\n insert into test(name) values ('foo'), ('foo')")
print(cu.rowcount)
cu.execute("/* bar */ insert into test(name) values ('x')")
print(cu.rowcount)
for q in ("select 1; -*not a comment", "select 1; -\n- select 2", "select 1; /* */ a", "select 1; /**/a"):
    try:
        cu.execute(q)
        print("no error", repr(q))
    except sqlite3.ProgrammingError as e:
        print("error", repr(q))
cx.close()
