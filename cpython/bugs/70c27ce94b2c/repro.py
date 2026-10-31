import os
os.environ["FORCE_COLOR"] = "1"
os.environ.pop("NO_COLOR", None)
import argparse
parser = argparse.ArgumentParser(color=True, prog="PROG")
group = parser.add_mutually_exclusive_group()
group.add_argument('--foo', action='store_true')
group.add_argument('--spam')
group.add_argument('badger', nargs='*')
print(repr(parser.format_usage()))
