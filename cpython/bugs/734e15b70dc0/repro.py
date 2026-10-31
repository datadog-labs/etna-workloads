import argparse

class Fmt(argparse.HelpFormatter):
    def __init__(self, prog):
        super().__init__(prog, max_help_position=40, width=80)

p = argparse.ArgumentParser(prog='PROG', formatter_class=Fmt)
p.add_argument('--foo', help='foo help')
print(p.format_help())
