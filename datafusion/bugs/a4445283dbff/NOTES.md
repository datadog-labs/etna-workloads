repro.sql copies the new select.slt test (issue #12183): it creates `test(a)` and selects `"test.a"` from a subquery that aliases `a AS "test.a"`.

- df-clean returns the single row `1`.
- df-buggy fails with an optimizer error. The `optimize_projections` invariant check reports a schema mismatch, because the qualifier is lost when the expression is rewritten. The original schema field is `test.a` with no qualifier. The new one is `a` with qualifier `test`.
