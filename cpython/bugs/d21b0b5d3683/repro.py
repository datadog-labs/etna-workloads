import argparse
for order in (0, 1):
    p = argparse.ArgumentParser(prog='PROG')
    g = p.add_mutually_exclusive_group(required=True)
    if order:
        g.add_argument('bar', nargs='?')
        g.add_argument('--foo')
    else:
        g.add_argument('--foo')
        g.add_argument('bar', nargs='?')
    print(p.format_usage())
