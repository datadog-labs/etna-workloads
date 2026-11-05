# Rationale
File: src/backend/commands/prepare.c, function pg_prepared_statement().
Reverts the single hunk of fix_impl.patch: result_types is built unconditionally from
plansource->resultDesc, without a NULL check, instead of setting nulls[4] when there is no
result descriptor. For DML statements resultDesc is NULL, so result_desc->natts dereferences NULL (crash).

Failing oracle case: src/test/regress||prepare
