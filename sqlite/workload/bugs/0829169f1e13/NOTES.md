Reproducer for index7-6.2 (ticket 98d973b8f5). The partial index `i4 ON t4(c) WHERE d='xyz'` is wrongly judged usable
when t4 is joined with a flattened subquery: the buggy build checks the usability with the FROM-clause index
instead of the cursor number. The query `SELECT ... FROM (subquery), t4 WHERE c='abc'` then returns the
wrong result.
Clean shell: returns the row `1|xyz|abc|not xyz`. Buggy shell: returns no rows.
