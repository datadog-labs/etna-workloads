import dis

def f(l):
    for _ in range(100):
        l.append(1)

class MyList(list):
    pass

f(MyList())
ops = {i.opname for i in dis.get_instructions(f, adaptive=True)}
print("CALL_LIST_APPEND" in ops)
