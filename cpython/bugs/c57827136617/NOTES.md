Reproducer for argparse "--" handling between an option with nargs='*' and a subparser command.
It parses `--foo x y -- run a b -f c` and `--foo x -- -- run a b`, printing the namespace/error.
The clean interpreter strips the first "--" and parses; the buggy one differs (see ./check.sh).
