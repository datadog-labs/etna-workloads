class D:
    def __init__(self):
        D.deleted = False
    def __del__(self):
        D.deleted = True

def generator(arg):
    yield

g = generator(D())
g.close()
print("fresh:", D.deleted)

g = generator(D())
next(g)
g.close()
print("suspended:", D.deleted)
