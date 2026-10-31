repro.py computes `frozendict(a=1,b=2).items() ^ frozendict(b=2,c=3).items()` and prints it.
Clean: `{('a', 1), ('c', 3)}`. Buggy: `TypeError: frozendict object does not support item deletion`,
because the injection makes the temp dict in the items-xor helper a frozendict copy, which then can't be mutated.
