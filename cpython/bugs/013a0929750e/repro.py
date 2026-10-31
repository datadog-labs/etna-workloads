import argparse
p = argparse.ArgumentParser(prog='PROG', usage=None)
g = p.add_mutually_exclusive_group(required=True)
g.add_argument('--aaaaaaaaaaaaaaaaaaaa')
g.add_argument('--bbbbbbbbbbbbbbbbbbbb')
g.add_argument('--cccccccccccccccccccc')
g.add_argument('--dddddddddddddddddddd')
import os
os.environ['COLUMNS'] = '50'
print(p.format_usage())
