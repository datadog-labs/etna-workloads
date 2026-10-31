class EvilInt(int):
    def __neg__(self):
        return ""

i = -1 << 50
f = float(i) - 0.5
i = EvilInt(i)
print(f == i, f != i, f < i, f <= i, f > i, f >= i)
