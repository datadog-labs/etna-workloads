repro.sql queries table-valued functions wrapped in parentheses
(`FROM (json_each(...)) AS xyz`, `FROM (generate_series(...)) AS x`).
With the bug, the parser drops the function arguments when it unwraps the
parentheses, so the buggy shell returns wrong results/errors instead of the
rows the clean shell returns.
