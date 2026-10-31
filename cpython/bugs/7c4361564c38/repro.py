import hashlib, sys
for name in ('shake_128', 'shake_256'):
    for n in (-1, -10, -(1 << 31), -sys.maxsize):
        for meth in ('digest', 'hexdigest'):
            h = getattr(hashlib, name)(usedforsecurity=False)
            try:
                r = getattr(h, meth)(n)
                print(name, meth, n, 'returned', repr(r)[:40])
            except BaseException as e:
                print(name, meth, n, type(e).__name__)
