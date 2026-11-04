repro.sql builds a column carrying field metadata via `with_metadata(nm, 'k', 'v')`, then runs `LAG(nm) OVER (ORDER BY ts)` in a subquery with an outer COUNT/CASE aggregate (the shape of the upstream metadata.slt test for issue #18337).

Clean build: returns `foo | 1`.
Buggy build: window function output fields lose their metadata in the logical schema, so planning fails with "Internal error: Physical input schema should be the same as the one converted from logical input schema ... field metadata at index 1 [prev_value]". The exit status is 0 on both builds, so only the output differs.
