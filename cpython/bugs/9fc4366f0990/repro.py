import argparse
import _colorize
_colorize.can_colorize = lambda *a, **k: True
parser = argparse.ArgumentParser(prog='complex', color=True)
sub = parser.add_subparsers(dest='command')
demo = sub.add_parser('demo')
print(repr(demo.prog))
