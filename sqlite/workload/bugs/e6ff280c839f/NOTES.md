Sets the expression depth limit to 11 and runs a query with a chain of 11 nested CTEs.
Clean shell: "VIEWs and/or subqueries nested too deep". Buggy shell: returns 1, because CTE resolution no longer counts nesting depth.
