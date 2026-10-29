repro.sql creates a column with `DEFAULT -1` and runs `PRAGMA table_info`.
Clean shell reports dflt_value `-1`; the buggy shell reports `-` (the default's text span covers only the minus token).
