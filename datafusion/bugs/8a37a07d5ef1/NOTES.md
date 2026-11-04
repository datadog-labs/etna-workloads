repro.sql calls to_date / to_timestamp / to_unixtime with a NULL string input, with all-NULL formats, and with a NULL format column (per-row array formats).

df-clean returns NULL for the NULL cases and parses row 1 correctly in the array case.
df-buggy raises "Internal error: a should not be None" / "ret should not be None" for the scalar cases. For the array case it treats the NULL format as '' and fails with "Error parsing timestamp ... using format ''".
