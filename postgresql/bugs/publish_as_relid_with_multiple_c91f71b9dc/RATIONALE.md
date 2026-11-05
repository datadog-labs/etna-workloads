# Rationale

File/function: src/backend/replication/pgoutput/pgoutput.c, get_rel_sync_entry().
Traces to the fix.patch hunk that adds the "publish_ancestor_level > ancestor_level" check
(top-most ancestor across all publications). Current code has this logic plus rel_publications
tracking. I removed the `if (publish_ancestor_level > ancestor_level) continue;` skip and changed
`<` to `!=`, so the last matching publication always sets publish_as_relid, even if it is a lower
ancestor level (child) than one already chosen. With multiple publications, changes may be
published via the wrong (non-topmost) relation, the original bug.

Failing oracle cases: src/test/subscription|t/013_partition.pl|inserts into tab4 replicated#2
