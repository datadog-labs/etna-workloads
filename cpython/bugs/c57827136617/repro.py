import argparse
parser = argparse.ArgumentParser(exit_on_error=False)
parser.add_argument('--foo', nargs='*')
subparsers = parser.add_subparsers()
parser1 = subparsers.add_parser('run')
parser1.add_argument('-f')
parser1.add_argument('bar', nargs='*')
print(parser.parse_args(['--foo', 'x', 'y', '--', 'run', 'a', 'b', '-f', 'c']))
try:
    parser.parse_args(['--foo', 'x', '--', '--', 'run', 'a', 'b'])
except argparse.ArgumentError as e:
    print(e)
