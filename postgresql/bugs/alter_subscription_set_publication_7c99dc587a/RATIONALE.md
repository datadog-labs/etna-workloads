# Rationale

## src/backend/replication/pgoutput/pgoutput.c, LoadPublications()
Traces to the single implementation hunk in fix.patch. The fix made
`GetPublicationByName(pubname, true)` (missing_ok) and skipped missing publications
with a WARNING. I reverted it to `GetPublicationByName(pubname, false)`, which errors
out when a publication does not exist, and removed the warning and its comment.
As a result, a walsender that starts replication (or reloads publications) before a
publication exists fails, which breaks ALTER SUBSCRIPTION ... SET/ADD PUBLICATION
for publications created later.

## Failing oracle cases
Run of the 024_add_drop_pub.pl oracle cases (the "check initial data is copied to subscriber"
cases and "check that the incremental data is replicated after the publication is created"). See oracle output.

Failing (oracle run):
- src/test/subscription|t/024_add_drop_pub.pl|check that the incremental data is replicated after the publication is created  (reported as 'missing')
