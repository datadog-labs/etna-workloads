import argparse
p = argparse.ArgumentParser(prog='PROG')
g = p.add_mutually_exclusive_group()
g.add_argument('--foo', help=argparse.SUPPRESS)
g.add_argument('--bar', help=argparse.SUPPRESS)
p.add_argument('--baz')
print(p.format_usage())
