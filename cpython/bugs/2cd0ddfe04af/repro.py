print(repr(frozendict(a=1, b=2).items() ^ frozendict(b=2, c=3).items()))
