import csv, io

class BadDialect:
    def __getattr__(self, name):
        raise RuntimeError("boom")

for make in (lambda: csv.reader([], dialect=BadDialect()),
             lambda: csv.writer(io.StringIO(), dialect=BadDialect())):
    try:
        make()
        print("no exception")
    except Exception as e:
        print(type(e).__name__, e)
