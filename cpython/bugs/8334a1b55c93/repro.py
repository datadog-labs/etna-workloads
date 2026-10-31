class evil:
    def __init__(self, lst):
        self.lst = lst
    def __iter__(self):
        yield from self.lst
        self.lst.clear()

lst = list(range(5))
try:
    lst[::-1] = evil(lst)
except ValueError as e:
    print("ValueError", e)
print(lst)
