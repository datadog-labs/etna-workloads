repro.sql: json_valid() on valid JSON, in the same statement as a json_set() that edits a cached parse.
Clean: `[31,2]|1` and `1`. Buggy: json_valid() reuses the cached, edited parse and returns `0` in both queries.
