import csv

class ReentrantIter:
    def __init__(self):
        self.reader = None
        self.n = 0
    def __iter__(self):
        return self
    def __next__(self):
        self.n += 1
        if self.n == 1:
            try:
                next(self.reader)
            except StopIteration:
                pass
            return "a,b"
        if self.n == 2:
            return "x"
        raise StopIteration

it = ReentrantIter()
reader = csv.reader(it)
it.reader = reader
try:
    print(next(reader))
except csv.Error as e:
    print("csv.Error", e)
