import argparse
parser = argparse.ArgumentParser(prog='PROG')
parser.add_argument('--foo', required=True)
parser.add_argument('--bar')
subparsers = parser.add_subparsers()
sub = subparsers.add_parser('sub')
sub.add_argument('arg')
print(repr(sub.format_usage()))
