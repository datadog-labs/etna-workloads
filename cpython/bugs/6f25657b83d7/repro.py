import fileinput

with open('t.txt', 'wb') as f:
    f.write(b'data\n')
try:
    with fileinput.hook_compressed('t.txt', 'rb') as f:
        print(repr(f.read()))
except Exception as e:
    print(type(e).__name__, e)
