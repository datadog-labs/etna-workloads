import argparse
parser = argparse.ArgumentParser(prog='PROG')
parser.add_argument('--foo', metavar='', required=True)
parser.add_argument('--bar', metavar='X' * 80, required=True)
print(parser.format_usage())
