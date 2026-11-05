# Rationale

Changed: src/backend/utils/cache/relcache.c, `RelationBuildPublicationDesc()` (successor of `GetRelationPublicationActions()` in fix.patch).

The fix.patch hunk added an early return when `!is_publishable_relation(relation)`, so temp/unlogged tables publish no actions. In today's code that early return builds a zeroed PublicationDesc with the *_valid_* flags set. I removed this block. Temp and unlogged tables in FOR ALL TABLES publications are again treated as publishing actions, so UPDATE/DELETE without a replica identity errors out.

Failing oracle cases:
- update to temporary table without replica identity with FOR ALL TABLES publication
- update to unlogged table without replica identity with FOR ALL TABLES publication
