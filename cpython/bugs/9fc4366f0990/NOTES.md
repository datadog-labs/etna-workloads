repro.py forces _colorize.can_colorize to True (as the test does), creates a parser with color=True,
adds a subparser, and prints the subparser's prog.
Clean: 'complex demo'. Buggy: prog contains ANSI escape codes, because the formatter used to compute prog is colorized.
