# Rationale

File: src/backend/optimizer/path/joinpath.c, function allow_star_schema_join() (called from try_nestloop_path).
Traces to the fix.patch hunk in try_nestloop_path that adds the star-schema override of the param_source_rels heuristic. In current code that logic lives in allow_star_schema_join(). It now always returns false, so a nestloop whose outer rel supplies only part of the inner path's parameterization is rejected when it doesn't overlap param_source_rels. This is the pre-fix behavior, and star-schema plans are lost.

Failing oracle case: src/test/regress||join
