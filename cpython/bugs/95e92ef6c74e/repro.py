import argparse
class C:
    pass
p = argparse.ArgumentParser()
sub = p.add_subparsers()
s = sub.add_parser('x')
s.add_argument('-w', type=int)
try:
    print(repr(p.parse_known_args(['x', '-w', '7', '-p'], namespace=C)))
    print(C.w, C._UNRECOGNIZED_ARGS_ATTR if hasattr(C, '_UNRECOGNIZED_ARGS_ATTR') else '')
except Exception as e:
    print(type(e).__name__, e)
