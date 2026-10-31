Reproducer: pprint.pprint() with sys.stdout redirected to None.
Clean: prints "ok". Buggy: AttributeError (NoneType has no write) traceback, exit 1.
