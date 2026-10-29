Creates an fts4 table with a notindexed column, inserts a row, and runs 'integrity-check'.
Clean: succeeds and prints ok. Buggy: the check tokenizes the notindexed column too, so the
index hash no longer matches and it fails with "database disk image is malformed".
