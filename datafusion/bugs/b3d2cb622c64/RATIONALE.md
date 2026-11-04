# Rationale

Fix: in `datafusion/sql/src/select.rs`, alias names turned into `Column` for ORDER BY handling must use `Column::new_unqualified()` rather than `.into()`. `.into()` goes through `from_qualified_name()`, which lowercases the identifier, so `"Count"` becomes `count`.

In 55.2.0 the code moved, but both sites still exist, and I reverted both:

1. The `find_map` over `select_exprs_post_aggr` (~line 1329) that rewrites a sort expression to its alias. This reverses hunk 3 (`return Some(Expr::Column(alias.name.clone().into()))`).
2. The `all_valid_exprs` chain (~line 1345). This reverses hunk 4 (`Some(Expr::Column(alias.name.clone().into()))`).

The import hunk was not reversed. `Column` is still used elsewhere in the file.

## Oracle
`order.slt` fails on the added regression query (`group by x order by 2 desc` with alias `"Count"`). The error is "Column in ORDER BY must be in GROUP BY or an aggregate function ... column "Count" must appear in the GROUP BY clause", which is the error the fix describes.
