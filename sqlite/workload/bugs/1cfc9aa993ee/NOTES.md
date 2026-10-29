repro.sql creates a table whose column default is the aggregate `max(1)`, then inserts a row that uses the default.
Clean shell: "Parse error near line 2: unknown function: max()", exit 1.
Buggy shell: segfault (exit -11), because the aggregate is coded as a scalar function.
