repro.py: a generator catches GeneratorExit and returns 0; it prints the result of close() twice.
Clean: `0` then `None`. Buggy: `None` then `None` (close() drops the generator's return value).
