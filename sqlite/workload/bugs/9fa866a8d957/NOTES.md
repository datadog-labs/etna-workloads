repro.sql checks JSON numbers with leading zeros (`01`, `-01`, `[00]`, `{"a":012}`).
Clean: json_valid returns 0 for all, and json('[01]') errors "malformed JSON".
Buggy: json_valid returns 1 for all, and json('[01]') returns `[01]`.
