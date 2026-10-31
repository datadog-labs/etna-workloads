repro.py runs `python -m pdb main.py`, rewrites main.py from inside pdb (with a 1s sleep for mtime resolution), then issues `restart`.
Prints whether the "was edited" stale-code warning appeared in stdout.
Clean: False. Buggy (warning now checked on every command): True.
