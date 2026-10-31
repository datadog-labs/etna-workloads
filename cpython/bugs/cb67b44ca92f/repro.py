import tempfile

f = tempfile.SpooledTemporaryFile(max_size=2)
states = []

def it():
    yield b'xy'
    states.append(f._rolled)
    yield b'z'
    states.append(f._rolled)

f.writelines(it())
print(states)
f.seek(0)
print(f.read())
f.close()
