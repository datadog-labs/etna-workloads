Calls `ArgumentParser.exit(0, 'foo')` with `sys.stderr` set to None (exit is mocked).
Clean: `_print_message` swallows the invalid stream and prints `ok`.
Buggy: `None.write` raises AttributeError (traceback, exit status 1).
