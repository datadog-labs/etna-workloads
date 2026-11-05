# Rationale
File: src/backend/catalog/system_views.sql, view pg_user_mappings (umoptions CASE).
Traces to the single fix_impl.patch hunk in the same view. The fix made umoptions for a
user's own mapping (umuser <> 0) also require USAGE on the server (owner role or
has_server_privilege), matching information_schema.user_mapping_options. I removed that
extra condition, so a user sees their own mapping's options even without server USAGE.

Failing oracle cases: src/test/regress||foreign_data, src/test/regress||rules
(rules fails because the view definition text changed).
