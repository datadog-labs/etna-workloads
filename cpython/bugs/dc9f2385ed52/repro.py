import argparse
f = argparse.HelpFormatter(prog="program")
f.add_usage(usage=None, actions=[], groups=[])
print(repr(f.format_help()))
