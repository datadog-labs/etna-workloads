Creates an fts4 table with order=DESC, inserts two rows, and runs 'integrity-check'.
Clean shell: succeeds silently. Buggy shell: the checksum code adds docid deltas instead of
subtracting them for descending indexes, so integrity-check fails with "database disk image is malformed".
