repro.sql checks which control characters (0x01-0x20) json_valid accepts inside a JSON string.
Clean: only 32 (space). Buggy: all of 1..32 are accepted, because the parser only rejects NUL, not other control characters.
