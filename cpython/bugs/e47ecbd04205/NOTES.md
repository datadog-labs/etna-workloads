Reproducer: `argparse` parser with count options `-k` and `-n`, then `parse_known_args(['-ku'])` and related cases.
Clean: `-ku` gives `(Namespace(known=1, new=0), ['-u'])`, with the unknown `-u` left in extras.
Buggy: `-ku` raises `ArgumentError: ignored explicit argument 'u'`.
