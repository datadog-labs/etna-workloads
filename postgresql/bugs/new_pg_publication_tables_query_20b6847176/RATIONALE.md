# Rationale
Hunk: src/backend/catalog/system_views.sql, view pg_publication_tables (attnames subquery).
Traces to the system_views.sql hunk of fix.patch (the catversion bump is not reproduced). The fix replaced the
pg_attribute scan filtered by `attnum > 0 AND NOT attisdropped AND (attnum = ANY(attrs) OR attrs IS NULL)`
with an unnest-based join. I restored the pre-fix form in today's code, so the view's attnames output
differs from what the expected output requires.

Failing oracle case: src/test/regress||rules
