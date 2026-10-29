repro.sql: LEFT JOIN with a WHERE-clause `t12.y IS t11.w` term (t11.w NULL, t12.y 'notnull').
Clean shell prints 0; the buggy shell lets the IS term drive an automatic index on the
LEFT JOIN's right-hand table, so it wrongly prints 1.
