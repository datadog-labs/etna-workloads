import random
r = random.Random()
r.seed(b'nofar', version=1)
print([r.random().hex() for i in range(4)])
