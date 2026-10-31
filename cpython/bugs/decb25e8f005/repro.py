import array

class Evil:
    def __init__(self, lst):
        self.lst = lst
    def __index__(self):
        self.lst.clear()
        return "not an int"

for typecode in "ILQ":
    lst = []
    lst.append(Evil(lst))
    a = array.array(typecode)
    try:
        a.fromlist(lst)
    except TypeError as e:
        print(typecode, "TypeError", e)
