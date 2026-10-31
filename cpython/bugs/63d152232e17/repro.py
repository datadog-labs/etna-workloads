import random

class R(random.Random):
    def __init__(self, vals):
        super().__init__(0)
        self.vals = iter(vals)
    def random(self):
        return next(self.vals)

print(repr(R([0.45]).gammavariate(1.0, 3.14)))
print(repr(R([1e-8]).gammavariate(1.0, 3.14)))
print(repr(R([1e-8]).expovariate(1.0 / 3.14)))
