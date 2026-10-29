Reproducer (repro.sql): a table with NULL and non-NULL `a` values, then `sum(b) OVER (ORDER BY a RANGE ... 10 FOLLOWING)` (window8-4.1.1 / 4.3.1).

The injection makes the NULLEQ comparison in OP_Eq/Ne/Lt/Le/Gt/Ge always return "greater" (res=1) when operands differ. That breaks RANGE window frame checks involving NULL peers.
Clean shell: 6,6,6,9,9 and 6,6,6,15,15. Buggy shell: every row is 15.
