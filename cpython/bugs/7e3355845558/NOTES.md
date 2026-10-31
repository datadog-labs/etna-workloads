Compiles a snippet with a valid `raise X from None` on line 2 and a real syntax error on line 3.
Clean: "invalid syntax" at line 3. Buggy: the invalid_raise_stmt rule fires on the valid line, giving "did you forget an expression after 'from'?" at line 2.
