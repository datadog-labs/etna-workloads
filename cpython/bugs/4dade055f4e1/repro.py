import array
a = array.array('i')
it = iter(a)
list(it)
it.__setstate__(0)
try:
    next(it)
except StopIteration:
    print("StopIteration")
