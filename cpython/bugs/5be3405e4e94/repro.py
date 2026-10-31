import argparse
parser = argparse.ArgumentParser(prog='PROG')
g = parser.add_mutually_exclusive_group()
g.add_argument('-v', '--verbose', action='store_true')
g.add_argument('-q', '--quiet', action='store_true')
g.add_argument('-x', '--extra-long-option-name', nargs='?')
g.add_argument('-y', '--yet-another-long-option', nargs='?')
g.add_argument('positional', nargs='?')
print(parser.format_usage())
