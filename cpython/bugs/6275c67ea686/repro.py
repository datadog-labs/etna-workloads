import traceback
def g():
    x = 1
    return (x + 1) / 0
try:
    g()
except Exception as e:
    fs = traceback.extract_tb(e.__traceback__)[-1]
    print(fs.line)
    print(fs.colno, fs.end_colno)
    print("\n".join(traceback.format_exception(e)[-2].splitlines()[1:]))
