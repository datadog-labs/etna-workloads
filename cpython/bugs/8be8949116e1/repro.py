big = 10 ** 100
one = 1
three = 3
print((big + 1) % big is one)
q, r = divmod(2 * big + 3, big)
print(r is three)
print(pow(2, 100, 2**100 - 3) is three)
