import argparse
p = argparse.ArgumentParser(prog='PROG')
p.add_argument('x', nargs=2, metavar=('A', 'B'))
p.add_argument('--y', nargs='+', metavar=('C', 'D'))
try:
    print(p.format_help())
except Exception as e:
    print(type(e).__name__, e)
try:
    p.parse_args(['--y', 'a', 'b'])
except SystemExit as e:
    print('exit', e.code)
