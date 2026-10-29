repro.sql builds a contentless_delete FTS5 table, overwrites the last ft_data tombstone
hash page with a corrupt, completely full page (8 slots of non-zero keys, 4-byte keys),
then runs `DELETE FROM ft WHERE rowid=1` (tombstone insert) and a query on `ft('two')`.
Clean shell: finishes, prints `2`. Buggy shell (nCollide guards removed): the probe loop
over the full hash page never terminates, so it hangs (timeout).
