import argparse
p = argparse.ArgumentParser(prog='p', exit_on_error=False)
p.add_argument('bar')
p.add_argument('baz', nargs='*')
try:
    p.parse_args([])
except argparse.ArgumentError as e:
    print(e)
p = argparse.ArgumentParser(prog='p')
g = p.add_mutually_exclusive_group()
g.add_argument('--foo', action='store_true')
g.add_argument('badger', nargs='*')
print(p.parse_args([]))
