d = {0: 0}
try:
    for i in d:
        del d[0]
        d[0] = 0
    print("no error")
except RuntimeError as e:
    print("RuntimeError:", e)
