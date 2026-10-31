import argparse
p = argparse.ArgumentParser(exit_on_error=False)
p.add_argument('--foodle')
p.add_argument('--foonly')
sub = p.add_subparsers()
b = sub.add_parser('bar')
b.add_argument('--fo')
b.add_argument('--foonew')
try:
    print(p.parse_args(['bar', '--fo', 'baz']))
except Exception as e:
    print(type(e).__name__, e)
