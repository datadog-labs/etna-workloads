import argparse
parent = argparse.ArgumentParser(add_help=False)
g = parent.add_argument_group(title='g', description='gd')
g.add_argument('-w')
m = g.add_mutually_exclusive_group()
m.add_argument('-y')
m.add_argument('-z')
parser = argparse.ArgumentParser(prog='PROG', parents=[parent], exit_on_error=False)
try:
    print(parser.parse_args(['-y', 'Y', '-z', 'Z']))
except argparse.ArgumentError as e:
    print('error', e)
print(parser.format_help())
