SELECT value FROM generate_series WHERE (start=1 AND stop=3) OR (start=1 AND stop=2 COLLATE nocase);
