import enum
try:
    it = enum._iter_bits_lsb(-4)
    print([next(it) for _ in range(3)])
except ValueError as e:
    print('ValueError', e)
