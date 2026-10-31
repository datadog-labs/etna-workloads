Builds a parser with a required `--foo` and optional `--bar`, adds a subparser, and prints the subparser's usage.
Clean: `'usage: PROG --foo FOO sub [-h] arg\n'`. Buggy: the parent's required optional is missing (`'usage: PROG sub [-h] arg\n'`).
