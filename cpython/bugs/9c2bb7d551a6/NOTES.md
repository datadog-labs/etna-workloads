Runs `python -m pdb s.py --bar foo` as a subprocess. Clean: exit 0, script sees
argv `['--bar', 'foo']`. Buggy: pdb's argparse rejects the option-like script
args ("unrecognized arguments: --bar foo"), exit 2, script never runs.
