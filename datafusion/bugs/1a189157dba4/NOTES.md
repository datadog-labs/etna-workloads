Reproducer for the filtered semi sort-merge join losing earlier spilled slices of an inner key group.
repro.sql forces a sort-merge join with a 64K memory limit. The query is a correlated EXISTS with a filter, so it runs as a filtered LeftSemi join. The inner key group (20,000 rows, key 2) spills several times.
Only the first inner batch satisfies the filter (`v <= 200`).
df-clean returns one row (k=2). df-buggy returns zero rows, because each spill replaced the previous spill file.
