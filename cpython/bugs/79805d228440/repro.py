import argparse
parser = argparse.ArgumentParser()
try:
    parser.add_argument('--no-foo', action=argparse.BooleanOptionalAction)
except ValueError as e:
    print(repr(str(e)))
else:
    print('no error')
