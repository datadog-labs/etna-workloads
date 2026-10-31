repro.py sets PYTHONTZPATH to a relative path and calls `zoneinfo.reset_tzpath()` while recording warnings. It prints the category and filename the InvalidTZPathWarning is attributed to.

- Clean: `InvalidTZPathWarning repro.py`. The warning points at the caller.
- Buggy: `InvalidTZPathWarning _tzpath.py`. The injection removes the `stacklevel`, so the warning points inside zoneinfo.

I ran both interpreters directly, because `./check.sh` fails in the sandbox with a bwrap error about a missing `.claude/launch.json`.
