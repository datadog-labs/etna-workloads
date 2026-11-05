# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit d166eed302400a71eed1aaa301d30be3af7b5715 ("Fix indentation of JOIN clauses in rule/view dumps."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/utils/adt/ruleutils.c

Failing oracle cases:
- `src/test/regress||create_view`
- `src/test/regress||rangefuncs`
- `src/test/regress||rules`
