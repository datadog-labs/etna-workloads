repro.sql runs the window1-55.1 query (ticket c8d3b9f0a750a529): a compound SELECT whose
first arm contains a scalar subquery with GROUP BY/HAVING and a window function over SUM(DISTINCT b).
Clean shell prints `99` and exits 0. The buggy shell crashes with SIGSEGV (exit -11), because the
AggInfo persist walk removed by injection.patch is missing, leaving dangling AggInfo pointers.
