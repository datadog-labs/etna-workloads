from concurrent import interpreters

code = (
    "import datetime;"
    "d = datetime.datetime.strptime('2000-01-01', '%Y-%m-%d');"
    "print(d.strftime('%Y%m%d'))"
)
for i in range(3):
    interp = interpreters.create()
    try:
        interp.exec(code)
    except interpreters.ExecutionFailed as e:
        print("failed:", e.excinfo.type, e.excinfo.msg)
    interp.close()
print("done")
