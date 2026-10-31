import argparse
parser = argparse.ArgumentParser(exit_on_error=False)
parser.add_argument('--foo', nargs='...')
parser.add_argument('bar', nargs='*')
for argv in (['--foo', '--', 'a', 'b'], ['--foo', 'a', '--', 'b'], ['--foo', 'a', 'b', '--']):
    try:
        print(parser.parse_args(argv))
    except Exception as e:
        print(type(e).__name__, e)
