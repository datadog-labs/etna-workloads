pprint.pformat of a dict subclass whose custom __repr__ returns a long string (>80 chars).
Clean: prints the custom repr. Buggy: the injected isinstance(dict) branch in
PrettyPrinter._format ignores the override and pretty-prints the dict contents ("{5: 6}").
