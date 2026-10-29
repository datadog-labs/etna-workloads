repro.sql: `SELECT json('{x:''a "b" c''}');` (JSON5 single-quoted string containing double quotes).
Clean shell: `{"x":"a \"b\" c"}`. Buggy shell: `{"x":"a "b" c"}` (double quotes not escaped, invalid JSON).
