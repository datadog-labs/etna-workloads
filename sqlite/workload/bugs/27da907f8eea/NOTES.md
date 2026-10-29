`repro.sql` is the setup and query from window1-64.3. It selects `count() OVER ()` together with `max(b COLLATE nocase)||''` in the ORDER BY of a GROUP BY query.

The window rewrite drops the EP_Collate flag from the rewritten expression, so the ORDER BY loses its NOCASE collation.

- Clean shell: rows come out in case-insensitive order (abcd, BCDE, cdef, DEFG).
- Buggy shell: rows come out in binary order (BCDE, DEFG, abcd, cdef).
