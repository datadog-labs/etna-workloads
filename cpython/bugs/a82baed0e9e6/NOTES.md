Calls `traceback.print_exception(42)` and prints the exception raised.
Clean: `TypeError Exception expected for value, int found`.
Buggy: the isinstance check is missing, so it fails with an AttributeError (`'int' object has no attribute '__traceback__'`) instead of the TypeError.
