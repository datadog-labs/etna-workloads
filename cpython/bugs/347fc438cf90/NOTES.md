repro.py calls os.posix_spawn with setpgroup=None, scheduler=None, and invalid scheduler values (1, [1, 2]), and prints the result or exception for each.

- Clean: None is accepted (child exits 0); invalid schedulers raise `TypeError: posix_spawn: scheduler must be a tuple or None`.
- Buggy: setpgroup=None raises TypeError; scheduler=None and invalid values raise SystemError ("new style getargs format but argument is not a tuple").

Note: ./check.sh failed in my sandbox (bwrap missing .claude/launch.json), so I compared the two interpreters by running them directly.
