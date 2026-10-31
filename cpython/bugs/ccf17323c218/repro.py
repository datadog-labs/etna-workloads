def f():
    lambda: k
    k = 1
    lst = [locals() for k in [0]]
    print(lst[0]['k'])
f()
