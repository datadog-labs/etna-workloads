from itertools import pairwise

for maxcount in (1, 2, 3, 4):
    class I:
        count = 0
        def __iter__(self):
            return self
        def __next__(self):
            if self.count >= maxcount:
                raise StopIteration
            self.count += 1
            if self.count == 1:
                return next(it, None)
            return [self.count]

    it = pairwise(I())
    print(maxcount, list(it))
