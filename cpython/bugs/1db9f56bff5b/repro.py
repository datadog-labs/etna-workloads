import argparse
p = argparse.ArgumentParser(prog='PROG')
p.add_argument('--foo')
p.add_mutually_exclusive_group()
try:
    print(p.format_usage())
except Exception as e:
    print(type(e).__name__)

p = argparse.ArgumentParser(prog='PROG')
g = p.add_mutually_exclusive_group()
g.add_argument('--a')
g.add_argument('b', nargs='?')
print(p.format_usage())
