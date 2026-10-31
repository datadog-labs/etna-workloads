import argparse, io, _colorize

calls = []
def fake_can_colorize(*, file=None):
    calls.append(file)
    return file is None

_colorize.can_colorize = fake_can_colorize
p = argparse.ArgumentParser(prog='PROG', color=True)
p.add_argument('--opt')
out = io.StringIO()
p.print_help(file=out)
print(out.getvalue().count('\x1b['), [c is out for c in calls])
