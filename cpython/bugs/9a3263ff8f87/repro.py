import argparse
p = argparse.ArgumentParser(prog='PROG', color=True)
p.add_argument('--hex', type=int, default=255, help='hex: %(default)x, pct: %(default)d%%')
try:
    print(repr(p.format_help()))
except Exception as e:
    print(type(e).__name__, e)
