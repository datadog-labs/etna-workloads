repro.sh creates a 1024-byte-page db with one REAL row (0.5), overwrites the 8-byte
float at offset 2040 with a NaN bit pattern (7FF8000000000000), then selects it.
Clean: `|null` (NaN read from disk becomes NULL). Buggy: `NaN|real`.
