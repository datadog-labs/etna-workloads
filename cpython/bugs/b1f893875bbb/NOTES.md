repro.py parses 'except A, B:' (and except*) with feature_version=(3,13). Clean raises SyntaxError (PEP 758 needs 3.14); buggy parses silently, printing 'parsed'.
