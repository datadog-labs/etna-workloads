Runs `python -m pdb -- s.py -foo` and `python -m pdb --`. Clean: the `--` separator is
accepted (script runs, exit 0) and bare `--` errors "missing script or module to run".
Buggy: both fail with "unrecognized arguments: --" (exit 2).
