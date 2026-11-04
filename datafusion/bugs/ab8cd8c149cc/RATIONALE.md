# Rationale

Fix hunk: in `multi_group_by/primitive.rs`, `equal_to` compared group values with `==` and the fix changed it to `ArrowNativeTypeOp::is_eq`, so NaN equals NaN.

In 55.2.0 the same comparison exists in three places, each using `is_eq(... .canonicalize())`:
`vectorized_equal_to_non_nullable`, `vectorized_equal_nullable` and `GroupColumn::equal_to`.
I changed all three back to native `==` / `!=` (keeping `canonicalize()`, which is unrelated to NaN). For floats `NaN == NaN` is false, which is the pre-fix behaviour. The three sites are one defect, because they are the same comparison on different paths.

Oracle: the added case in aggregate.slt (`COUNT(DISTINCT column2)` over two NaN rows grouped by 'x') now returns `x 2` instead of `x 1`.
The check also listed three other mismatches (approx_percentile_cont_with_weight results). I did not touch that code and did not investigate them.
