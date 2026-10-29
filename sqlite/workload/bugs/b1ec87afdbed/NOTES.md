repro.sql runs the select4-17.2 query: a compound subquery whose first term is an aggregate (GROUP BY/sum) and whose last term is not, filtered by an outer WHERE.
Clean shell returns `1|20` and `98|99`. The buggy shell pushes the WHERE into the aggregate term as a plain WHERE instead of HAVING, so it fails with "misuse of aggregate: sum()" (exit status 1).
