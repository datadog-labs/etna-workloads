repro.py builds a TimedRotatingFileHandler (when='MIDNIGHT', interval=2, utc=True, delay=True) and prints computeRollover(t) - t for a fixed t.

Clean: 92800 (next midnight plus the extra interval day). Buggy: 6400 (the interval is ignored, so rollover is at the next midnight only).
