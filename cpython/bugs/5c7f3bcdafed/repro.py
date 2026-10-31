from fileinput import FileInput

with open('t.txt', 'wb') as f:
    f.write(b'Initial text \x88')
try:
    with FileInput('t.txt', inplace=True, encoding='ascii', errors='replace') as fobj:
        line = fobj.readline()
        print("New line \x88")
except Exception as e:
    import sys
    print(type(e).__name__, file=sys.__stderr__)
    print(type(e).__name__)
else:
    print(repr(line))
with open('t.txt', 'rb') as f:
    print(repr(f.read()))
