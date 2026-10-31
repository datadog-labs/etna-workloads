repro.py execs three snippets using dotted `from .__future__ import ...` (from test_future_dotted_import) and prints the exception raised by each.
Clean: ImportError for the first two, and SyntaxError (late __future__ import) for the third.
Buggy: the dotted import is treated as a real future statement, so the first two give SyntaxError "future feature ... is not defined", and the third raises ImportError instead of SyntaxError.
