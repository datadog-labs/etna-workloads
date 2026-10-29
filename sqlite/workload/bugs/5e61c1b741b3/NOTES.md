Reproducer: calls row_number(x) OVER () (a built-in window function with the wrong argument count).
Clean shell: "wrong number of arguments to function row_number()". Buggy shell: reports a different error ("FILTER may not be used with non-aggregate row_number()") because the injected check fires first.
