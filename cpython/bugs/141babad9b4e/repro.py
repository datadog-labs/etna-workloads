class Evil:
    def __lt__(self, other):
        other.clear()
        return NotImplemented


a = [[Evil()]]
try:
    a[0] < a
    print("no exception raised")
except TypeError:
    print("TypeError raised")
