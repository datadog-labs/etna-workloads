import argparse
p = argparse.ArgumentParser(prog='PROG', usage='PROG [--foo] bar 1 [-w W] {a,b,c}')
p.add_argument('--foo')
sub = p.add_subparsers()
s = sub.add_parser('a')
s.add_argument('x')
print(repr(sub._prog_prefix))
