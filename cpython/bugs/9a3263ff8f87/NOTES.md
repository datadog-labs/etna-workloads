`repro.py` builds an `ArgumentParser(color=True)` with an argument whose help uses `%(default)x` and `%(default)d%%`, then prints `format_help()`.

- clean: help renders (`hex: ff, pct: 255%`), exit 0.
- buggy: every param is wrapped in colour codes before `%` interpolation, so `%x` gets a str. `add_argument` raises `ValueError: badly formed help string` and the script exits 1.
