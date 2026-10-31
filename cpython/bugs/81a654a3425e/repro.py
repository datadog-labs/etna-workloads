import argparse
p = argparse.ArgumentParser(exit_on_error=False)
p.add_argument('x')
try:
    p.parse_args([])
except argparse.ArgumentError as e:
    print('ArgumentError:', e)
