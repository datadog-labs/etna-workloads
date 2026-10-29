repro.sql builds t1/t3 and runs a query with a correlated scalar subquery (referencing outer column `a`) next to a window function (`sum(a) OVER (ORDER BY a)`), as in window6-11.2.

Clean shell: the subquery column returns `ten`, `fifteen`, `thirty` for matching rows.
Buggy shell: the window rewrite no longer descends into the subquery (selectWindowRewriteSelectCb prunes), so the subquery column is NULL for every row. This is a wrong result, with exit status 0 in both shells.
